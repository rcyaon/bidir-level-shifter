# Place and route the blocks above the leaf cells.
#
# Each block is built as one or more rows of components with a routing
# channel above every row:
#   - a component is a PDK standard cell (or a run of abutting ones), a leaf
#     cell from <leaf>.gds, a child block, or one or two MOSFET PCells with
#     their contacts and tap,
#   - every pin gets a vertical Metal2 stub up into the channel above its row,
#   - every net gets a horizontal Metal3 trunk in each channel it has pins in,
#   - a net that spans rows gets one vertical Metal4 riser joining its
#     trunks, placed as close to its pins as possible. A block's pins end as
#     Metal2 stubs on its top edge so the parent can pick them up the same way.
# The result is correct by construction and checked with DRC/LVS, but it is
# not compact: nothing shares diffusion and the channels are not optimised.
#
# Run inside the container, from layout/, with KLAYOUT_PATH set for
# ihp-sg13cmos5l (see README.md):
#   klayout -zz -r build_blocks.py -rd block=dff_c2mos
# An existing <block>.gds is replaced. Build children first.

import os
import sys
import pya

HERE = os.path.dirname(os.path.abspath(__file__))
TECH = "sg13cmos5l"
PITCH = 0.41          # Metal2 stub pitch (0.20 wide, 0.21 space)
TRACK = 0.42          # Metal3 trunk pitch
LV_LIB, HV_LIB = "sg13cmos5l_stdcell", "sg13cmos5l_stdcell_hv"

layout = pya.Layout()
layout.dbu = 0.001
layout.technology_name = TECH
LY = {n: layout.layer(*ld) for n, ld in dict(
    activ=(1, 0), poly=(5, 0), cont=(6, 0), m1=(8, 0), m1pin=(8, 2),
    m1txt=(8, 25), v1=(19, 0), m2=(10, 0), v2=(29, 0), m3=(30, 0),
    m3pin=(30, 2), m3txt=(30, 25), v3=(49, 0), m4=(50, 0), nwell=(31, 0),
    text=(63, 0)).items()}


def fail(msg):
    print(f"build_blocks: {msg}", file=sys.stderr)
    sys.exit(1)


def r5(v):
    """Snap to the 5 nm manufacturing grid."""
    return round(v / 0.005) * 0.005


def dev_lib():
    for lid in pya.Library.library_ids():
        lib = pya.Library.library_by_id(lid)
        if lib.name() == "SG13_dev" and TECH in lib.technologies():
            return lib
    fail("SG13_dev PCell library not loaded; see README.md")


def pcell(name, **params):
    lib = dev_lib()
    return layout.add_pcell_variant(lib, lib.layout().pcell_id(name), params)


def lib_cell(lib_name, name):
    lib = pya.Library.library_by_name(lib_name)
    if lib is None or lib.layout().cell(name) is None:
        fail(f"{name} not found in KLayout library {lib_name}")
    return layout.add_lib_cell(lib, lib.layout().cell(name).cell_index())


def gds_cell(name):
    """Cell index of leaf/child `name`, read from <name>.gds on first use."""
    cell = layout.cell(name)
    if cell is None:
        path = os.path.join(HERE, name + ".gds")
        if not os.path.isfile(path):
            fail(f"{name}.gds missing: build it first")
        opt = pya.LoadLayoutOptions()
        opt.cell_conflict_resolution = pya.LoadLayoutOptions.SkipNewCell
        layout.read(path, opt)
        cell = layout.cell(name)
    return cell.cell_index()


def merge_duplicate_proxies():
    """Point every instance of a duplicated library cell at one copy.

    Reading several child layouts brings in one proxy per file for the same
    standard cell or PCell variant (inv_1, inv_1$1, ...). LVS matches cells
    by name, so the copies would not be recognised as the schematic's cell.
    """
    first, remap = {}, {}
    for cell in layout.each_cell():
        lib = cell.library()
        if lib is None:
            continue
        key = (lib.name(), cell.library_cell_index(),
               repr(cell.pcell_parameters()) if cell.is_pcell_variant() else "")
        if key in first:
            remap[cell.cell_index()] = first[key]
        else:
            first[key] = cell.cell_index()
    for cell in layout.each_cell():
        for inst in cell.each_inst():
            if inst.cell_index in remap:
                inst.cell_index = remap[inst.cell_index]
    for ci in remap:
        layout.prune_cell(ci, -1)
    return len(remap)


def boxes(ci, layer):
    """Bounding boxes of a cell's own shapes on `layer` (PCells repeat some)."""
    seen = {}
    for s in layout.cell(ci).shapes(LY[layer]).each():
        seen.setdefault(str(s.dbbox()), s.dbbox())
    return list(seen.values())


class Comp:
    """Shapes, sub-instances and ports of one component, in local coordinates.

    A port is (net, via_x, via_y, stub_x, kind): kind "v1" gets a Via1 with
    its Metal1 pad at the via point, kind "m2" is Metal2 already (a child
    block's pin on its top edge). stub_x differs from via_x when the stub is
    jogged sideways on Metal2 to keep the stub pitch.
    """

    def __init__(self, well=None):
        self.shapes, self.insts, self.ports, self.vias = [], [], [], []
        # Net of the component's n-well, None without one, "*" for several.
        # Wells on different nets need 1.8 um between them (NW.b1).
        self.well = well
        self.has_m4 = False       # set for child blocks that hold Metal4 risers
        self.bbox = pya.DBox()

    def box(self, layer, x1, y1, x2, y2):
        b = pya.DBox(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))
        self.shapes.append((layer, b))
        self.bbox += b

    def inst(self, ci, dx=0.0, dy=0.0):
        self.insts.append((ci, dx, dy))
        self.bbox += layout.cell(ci).dbbox().moved(dx, dy)

    def port(self, net, x, y, stub_x=None, kind="v1", top=None):
        """`top`: add more vias above the first one, every 0.5 um up to there.

        They sit under the port's Metal2 stub, so a wide device is not fed
        through a single via.
        """
        self.ports.append((net, x, y, x if stub_x is None else stub_x, kind))
        k = 1
        while top is not None and y + 0.5 * k <= top + 1e-6:
            self.vias.append((x, r5(y + 0.5 * k)))
            k += 1


# ------------------------------------------------------------- components --

# Stub positions inside standard cells that can't take a via straight above
# every pin: {cell: {pin: stub_x}}, the via stays on the pin.
JOGS = {
    "sg13cmos5l_and3_1": {"A": 0.75},
    "sg13cmos5l_or2_1": {"A": 0.50},
    "sg13cmos5l_nor2_1": {"B": 0.91},
    "sg13g2_hv_nor2_2": {"B": 3.45},
}


def stdcells(lib_name, cells):
    """A run of abutting standard cells: [(cell_name, {pin: net}), ...].

    The rails are extended 0.5 um past both ends in Metal1; the VDD via sits
    on the left extension and the VSS via on the right one.
    """
    c = Comp(well=cells[0][1]["VDD"])
    lib_ly = pya.Library.library_by_name(lib_name).layout()
    x, rails = 0.0, {}
    for name, nets in cells:
        ci = lib_cell(lib_name, name)
        src = lib_ly.cell(name)
        width = [s.dbbox() for s in src.shapes(lib_ly.layer(189, 4)).each()][0].width()
        pins = pya.Region(src.shapes(lib_ly.layer(8, 2)))
        pins.merge()
        last = None
        found = []
        for s in src.shapes(lib_ly.layer(8, 25)).each():
            if not s.is_text():
                continue
            pt = pya.Point(s.text.x, s.text.y)
            rect = [p.bbox() for p in pins.each() if p.inside(pt)]
            if not rect:
                fail(f"{name}: no Metal1 pin shape under label {s.text.string}")
            found.append((s.text.string, pya.DBox(rect[0]) * layout.dbu))
        for pin, rect in sorted(found, key=lambda f: f[1].left):
            if pin in ("VDD", "VSS"):
                rails[pin] = (rect.bottom, rect.top, nets[pin])
                continue
            lo, hi = r5(rect.left + 0.105), r5(rect.right - 0.105)
            vx = lo if last is None else min(max(lo, last + PITCH), hi)
            vy = r5(min(max(rect.center().y, rect.bottom + 0.145), rect.top - 0.145))
            sx = JOGS.get(name, {}).get(pin, vx)
            if pin not in JOGS.get(name, {}):
                if last is not None and vx - last < PITCH - 1e-6:
                    fail(f"{name}: pin {pin} too close to its neighbour; add a JOGS entry")
                last = vx
            c.port(nets[pin], x + vx, vy, x + sx)
        c.inst(ci, x, 0.0)
        x += width
    for pin, vx in (("VDD", -0.30), ("VSS", x + 0.30)):
        y1, y2, net = rails[pin]
        c.box("m1", -0.5, y1, 0.0, y2)
        c.box("m1", x, y1, x + 0.5, y2)
        c.port(net, vx, r5((y1 + y2) / 2))
    return c


def leaf(name, ports, well):
    """A leaf cell from <name>.gds with hand-picked via points on its pins."""
    c = Comp(well=well)
    c.inst(gds_cell(name))
    for net, x, y in ports:
        c.port(net, x, y)
    return c


def child(name, nets, well="*"):
    """A child block built by this script: pins are Metal2 on its top edge."""
    c = Comp(well=well)
    ci = gds_cell(name)
    c.inst(ci)
    top = layout.cell(ci).dbbox().top
    c.has_m4 = not pya.Region(layout.cell(ci).begin_shapes_rec(LY["m4"])).is_empty()
    for s in layout.cell(ci).shapes(LY["text"]).each():
        if s.is_text() and s.text.string.startswith("pin:"):
            pin = s.text.string[4:]
            c.port(nets[pin], s.text.x * layout.dbu, top, kind="m2")
    return c


def gate_contact(c, gx1, gx2, y_poly, up, net=None):
    """Poly pad, contact and Metal1 pad on a gate; returns the via point."""
    gc = r5((gx1 + gx2) / 2)
    half = max(0.15, (gx2 - gx1) / 2)
    s = 1 if up else -1
    c.box("poly", gc - half, y_poly, gc + half, y_poly + s * 0.33)
    cy = r5(y_poly + s * 0.18)
    c.box("cont", gc - 0.08, cy - 0.08, gc + 0.08, cy + 0.08)
    c.box("m1", gc - 0.15, cy - 0.16, gc + 0.15, cy + 0.16)
    if net:
        c.port(net, gc, cy)
    return gc, cy


def mos_geom(ci):
    """(left terminal, right terminal, gate poly, guard ring or None)."""
    poly = boxes(ci, "poly")[0]
    m1 = boxes(ci, "m1")
    terms = sorted([b for b in m1 if b.bottom > -0.01 and b.left > -0.01 and b.top <= poly.top],
                   key=lambda b: b.left)
    ring = [b for b in m1 if b not in terms]
    outer = None
    for b in ring:
        outer = b if outer is None else outer + b
    return terms[0], terms[-1], poly, outer


def lv_mos(model, w, l, d, g, s, bulk=None):
    """One LV MOSFET: source/drain vias beside it, gate contact above.

    A PMOS gets an ntap1 in its well, wired to `bulk`. An NMOS relies on the
    substrate ties of the standard cells and guard rings around it.
    """
    name = "pmos" if "pmos" in model else "nmos"
    c = Comp(well=bulk if name == "pmos" else None)
    ci = pcell(name, model=model, w=f"{w}u", l=f"{l}u", ng="1")
    c.inst(ci)
    t1, t2, poly, _ = mos_geom(ci)
    y1 = r5(min(0.145, w / 2))
    y2 = r5(max(y1, w - 0.145))
    for term, net, sign in ((t1, s, -1), (t2, d, 1)):
        vx = r5((term.left if sign < 0 else term.right) + sign * 0.30)
        c.box("m1", vx - sign * 0.105, 0.0, term.center().x, 0.29)
        c.box("m1", vx - 0.105, y1 - 0.145, vx + 0.105, y2 + 0.145)
        if w >= 1.5:
            c.box("m1", vx - sign * 0.105, w - 0.29, term.center().x, w)
        c.port(net, vx, y1, top=y2)
    gate_contact(c, poly.left, poly.right, poly.top, True, g)
    if name == "pmos":
        add_ntap(c, t2.right + 0.30 + 0.105 + 0.30, 0.0, bulk)
    return c


def add_ntap(c, x0, y0, net):
    tap = pcell("ntap1", w="0.78u", l="0.78u")
    c.inst(tap, x0, y0)
    c.port(net, r5(x0 + 0.39), r5(y0 + 0.39))
    well = None
    for ci, dx, dy in c.insts:
        for b in boxes(ci, "nwell"):
            well = b.moved(dx, dy) if well is None else well + b.moved(dx, dy)
    c.box("nwell", well.left, well.bottom, well.right, well.top)


def tgate(wn, wp, a, b, gn, gp, vdd):
    """LV transmission gate: NMOS below, PMOS above, sides strapped in Metal1.

    The NMOS gate is contacted below the device and brought out to the left;
    the PMOS gate is contacted above it. One ntap1 ties the well to `vdd`.
    """
    c = Comp(well=vdd)
    n = pcell("nmos", model="sg13_lv_nmos", w=f"{wn}u", l="0.13u", ng="1")
    p = pcell("pmos", model="sg13_lv_pmos", w=f"{wp}u", l="0.13u", ng="1")
    p0 = r5(wn + 0.70)
    c.inst(n)
    c.inst(p, 0.0, p0)
    t1, t2, poly, _ = mos_geom(n)
    yn, yp = r5(max(wn / 2, 0.145)), r5(p0 + wp / 2)
    off = 0.30                # strap to terminal: 0.195 clear where they don't join
    for term, net, sign in ((t1, a, -1), (t2, b, 1)):
        vx = r5((term.left if sign < 0 else term.right) + sign * off)
        for y in (yn, yp):
            c.box("m1", vx - sign * 0.105, y - 0.145, term.center().x, y + 0.145)
        c.box("m1", vx - 0.105, yn - 0.145, vx + 0.105, yp + 0.145)
        c.port(net, vx, r5((yn + yp) / 2))
    left = r5(t1.left - off)
    gc, cy = gate_contact(c, poly.left, poly.right, poly.bottom, False)
    vx = r5(left - PITCH)
    c.box("m1", vx - 0.105, cy - 0.145, gc, cy + 0.145)
    c.port(gn, vx, cy)
    gate_contact(c, poly.left, poly.right, p0 + wp + 0.18, True, gp)
    add_ntap(c, t2.right + off + 0.105 + 0.30, p0, vdd)
    return c


def hv_mos(model, w, l, d, g, s, bulk):
    """One HV MOSFET in its PCell guard ring; the ring is the bulk tie."""
    c = Comp(well=bulk if "pmos" in model else None)
    name, ring_type = ("pmosHV", "nwell") if "pmos" in model else ("nmosHV", "psub")
    ci = pcell(name, model=model, w=f"{w}u", l=f"{l}u", ng="1", guardRingType=ring_type)
    c.inst(ci)
    t1, t2, poly, ring = mos_geom(ci)
    y1 = r5(min(0.145, w / 2))
    for term, net in ((t1, s), (t2, d)):
        c.port(net, r5(term.center().x), y1, top=w - 0.145)
    gate_contact(c, poly.left, poly.right, poly.top, True, g)
    c.port(bulk, r5(ring.left + 0.15), r5(ring.top - 0.15))
    return c


def mos_fingers(model, w, l, ng, d, g, s, bulk=None):
    """A multi-finger MOSFET (w is the total width): neighbouring fingers
    share their source/drain, so it is far narrower than `ng` single devices.

    Every source/drain strip is a port. HV gates are contacted one by one;
    LV gates are too close together for that and are joined by a poly bar
    with one contact at its left end.
    """
    hv, pm = "_hv_" in model, "pmos" in model
    params = dict(model=model, w=f"{w}u", l=f"{l}u", ng=str(ng))
    if hv:
        params["guardRingType"] = "nwell" if pm else "psub"
    ci = pcell(("pmos" if pm else "nmos") + ("HV" if hv else ""), **params)
    c = Comp(well=bulk if pm else None)
    c.inst(ci)
    polys = sorted(boxes(ci, "poly"), key=lambda b: b.left)
    m1 = boxes(ci, "m1")
    terms = sorted([b for b in m1 if b.bottom > -0.01 and b.left > -0.01 and b.top <= polys[0].top],
                   key=lambda b: b.left)
    if len(terms) != ng + 1 or len(polys) != ng:
        fail(f"{model} ng={ng}: unexpected PCell geometry")
    wf = terms[0].height()
    y1 = r5(min(0.145, wf / 2))
    for i, t in enumerate(terms):
        c.port(d if i % 2 else s, r5(t.center().x), y1, top=wf - 0.145)
    if hv:
        for poly in polys:
            gate_contact(c, poly.left, poly.right, poly.top, True, g)
        ring = None
        for b in m1:
            if b not in terms:
                ring = b if ring is None else ring + b
        c.port(bulk, r5(ring.left + 0.15), r5(ring.top - 0.15))
    else:
        x0 = r5(terms[0].left - 0.50)
        c.box("poly", x0, wf + 0.15, polys[-1].right, wf + 0.31)
        gate_contact(c, x0, x0 + 0.30, wf + 0.15, True, g)
        if pm:
            add_ntap(c, terms[-1].right + 0.30, 0.0, bulk)
    return c


def rppd(w, l, a, b):
    """Poly resistor; its two Metal1 heads get vias at different x."""
    c = Comp()
    ci = pcell("rppd", model="res_rppd", w=f"{w}u", l=f"{l}u", b=0)
    c.inst(ci)
    heads = sorted(boxes(ci, "m1"), key=lambda h: h.bottom)
    c.port(a, r5(heads[0].left + 0.23), r5(heads[0].center().y))
    c.port(b, r5(heads[1].right - 0.23), r5(heads[1].center().y))
    return c


# ------------------------------------------------------------------ router --

class Block:
    def __init__(self, name, pins, children=()):
        # Read child layouts before anything else is created: their standard
        # cells come back as library proxies and are then shared, instead of
        # clashing by name with proxies made here first.
        for c in children:
            gds_cell(c)
        self.name, self.pins = name, pins
        self.top = None
        self.rows = []
        self.new_row()

    def new_row(self):
        # comps: (comp, dx, dy, label); ports: (net, via_x, via_y, stub_x, kind),
        # y relative to the row's bottom; blocked: x ranges a Metal4 riser must avoid
        self.row = dict(comps=[], ports=[], vias=[], top=0.0, blocked=[])
        self.x, self.prev = 0.0, None

    @staticmethod
    def gap(a, b):
        apart = a.well and b.well and (a.well != b.well or "*" in (a.well, b.well))
        return 2.0 if apart else 0.7

    def pack(self, items, width):
        """Fill rows of about `width` with (comp, label) items, tallest first,
        so that each row holds components of similar height."""
        for comp, label in sorted(items, key=lambda it: -it[0].bbox.height()):
            row = self.row
            if row["comps"] and self.x + self.gap(self.prev, comp) + comp.bbox.width() > width:
                self.end_row()
            self.add(comp, label)

    def add(self, comp, label=None):
        row = self.row
        gap = self.gap(self.prev, comp) if row["comps"] else 0.0
        dx = r5(self.x + gap - comp.bbox.left)
        dy = r5(-comp.bbox.bottom)
        taken = [p[3] for p in row["ports"]]
        while any(abs(dx + p[3] - t) < PITCH - 1e-6 for p in comp.ports for t in taken):
            dx = r5(dx + 0.005)
        row["comps"].append((comp, dx, dy, label))
        for net, vx, vy, sx, kind in comp.ports:
            row["ports"].append((net, r5(vx + dx), r5(vy + dy), r5(sx + dx), kind))
        row["vias"] += [(r5(vx + dx), r5(vy + dy)) for vx, vy in comp.vias]
        if comp.has_m4:
            row["blocked"].append((comp.bbox.left + dx - 0.35, comp.bbox.right + dx + 0.35))
        self.x = comp.bbox.right + dx
        self.prev = comp
        row["top"] = max(row["top"], comp.bbox.height())

    def end_row(self):
        """Close the current row; the next one goes above its channel."""
        if self.row["comps"]:
            self.rows.append(self.row)
        self.new_row()

    def rect(self, layer, x1, y1, x2, y2):
        self.top.shapes(LY[layer]).insert(
            pya.DBox(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)))

    def via(self, layer, x, y):
        self.rect(layer, x - 0.095, y - 0.095, x + 0.095, y + 0.095)

    @staticmethod
    def free_x(want, taken, blocked=(), lo=0.0):
        """Nearest x to `want` that keeps the pitch to `taken` and avoids `blocked`."""
        for k in range(0, 100000):
            for x in (r5(want + k * 0.05), r5(want - k * 0.05)):
                if x >= lo and all(abs(x - t) >= PITCH - 1e-6 for t in taken) and \
                        not any(a <= x <= b for a, b in blocked):
                    return x
        fail("no free column")

    def route(self, dry=False):
        """Route and write the block. With `dry`, only return (width, height)."""
        self.end_row()
        rows, last = self.rows, len(self.rows) - 1
        in_rows = {}                                # net -> rows it has pins in
        for r, row in enumerate(rows):
            for p in row["ports"]:
                in_rows.setdefault(p[0], set()).add(r)
        missing = [p for p in self.pins if p not in in_rows]
        if missing:
            fail(f"{self.name}: pins with no connection: {missing}")
        for net in self.pins:                       # pins leave through the top channel
            in_rows[net].add(last)

        # Metal4 risers for nets in more than one row, as close to their pins
        # as the columns already taken and any Metal4 in child blocks allow.
        riser, taken = {}, []
        for net in sorted(in_rows, key=lambda n: (-len(in_rows[n]), n)):
            if len(in_rows[net]) < 2:
                continue
            xs = sorted(p[3] for row in rows for p in row["ports"] if p[0] == net)
            crossed = range(min(in_rows[net]) + 1, max(in_rows[net]) + 1)
            blocked = [b for r in crossed for b in rows[r]["blocked"]]
            riser[net] = self.free_x(xs[len(xs) // 2], taken, blocked)
            taken.append(riser[net])
        # Metal2 stubs that take the block's pins from the top channel to its top edge
        export, taken = {}, [p[3] for p in rows[last]["ports"]]
        for net in self.pins:
            xs = sorted(p[3] for p in rows[last]["ports"] if p[0] == net) or [riser[net]]
            export[net] = self.free_x(xs[len(xs) // 2], taken)
            taken.append(export[net])

        # left-edge track assignment per channel, then the row positions
        track = []                                  # per row: {net: (track, lo, hi)}
        for r, row in enumerate(rows):
            spans = {}
            for net, vx, vy, sx, kind in row["ports"]:
                spans.setdefault(net, []).append(sx)
            for net in in_rows:
                if r in in_rows[net]:
                    if net in riser:
                        spans.setdefault(net, []).append(riser[net])
                    if r == last and net in export:
                        spans.setdefault(net, []).append(export[net])
            used, assigned = [], {}
            for net in sorted(spans, key=lambda n: min(spans[n])):
                lo, hi = min(spans[net]), max(spans[net])
                hi = max(hi, lo + 0.75 - 0.29)      # minimum Metal3 area
                for k, right in enumerate(used):
                    if lo - right >= 0.29 + 0.25:
                        break
                else:
                    used.append(None)
                    k = len(used) - 1
                used[k] = hi
                assigned[net] = (k, lo, hi)
            track.append(assigned)
        y_row, y_chan, y = [], [], 0.0
        for r, row in enumerate(rows):
            y_row.append(y)
            y_chan.append(r5(y + row["top"] + 0.60))
            n = 1 + max(k for k, _, _ in track[r].values())
            # 1.9 um at least, for wells on different nets in neighbouring rows
            y = r5(max(y_chan[r] + (n - 1) * TRACK + 0.10 + 0.60, y_row[r] + row["top"] + 1.9))
        block_top = r5(y + 0.20)
        if dry:
            right = max([c[0].bbox.right + c[1] for row in rows for c in row["comps"]] +
                        list(riser.values()) + list(export.values()))
            return right + 0.3, block_top
        self.top = layout.create_cell(self.name)

        for r, row in enumerate(rows):
            y0 = y_row[r]
            for comp, dx, dy, label in row["comps"]:
                for ci, ix, iy in comp.insts:
                    self.top.insert(pya.DCellInstArray(
                        ci, pya.DTrans(pya.DVector(dx + ix, y0 + dy + iy))))
                for layer, b in comp.shapes:
                    self.top.shapes(LY[layer]).insert(b.moved(dx, y0 + dy))
                if label:
                    self.top.shapes(LY["text"]).insert(
                        pya.DText(label, comp.bbox.left + dx, y0 + row["top"] + 0.05))
            for vx, vy in row["vias"]:
                self.via("v1", vx, y0 + vy)
                self.rect("m1", vx - 0.105, y0 + vy - 0.145, vx + 0.105, y0 + vy + 0.145)
            for net, (k, lo, hi) in track[r].items():
                ty = r5(y_chan[r] + k * TRACK)
                self.rect("m3", lo - 0.145, ty - 0.10, hi + 0.145, ty + 0.10)
                for pnet, vx, vy, sx, kind in row["ports"]:
                    if pnet != net:
                        continue
                    vy = r5(y0 + vy)
                    if kind == "v1":
                        self.via("v1", vx, vy)
                        self.rect("m1", vx - 0.105, vy - 0.145, vx + 0.105, vy + 0.145)
                        if abs(sx - vx) > 1e-6:
                            self.rect("m2", min(vx, sx) - 0.145, vy - 0.10,
                                      max(vx, sx) + 0.145, vy + 0.10)
                    self.rect("m2", sx - 0.10, vy - 0.145, sx + 0.10, ty + 0.145)
                    self.via("v2", sx, ty)
        ty_of = lambda net, r: r5(y_chan[r] + track[r][net][0] * TRACK)
        for net, x in riser.items():
            ys = [ty_of(net, r) for r in sorted(in_rows[net])]
            self.rect("m4", x - 0.10, ys[0] - 0.145, x + 0.10, ys[-1] + 0.145)
            for ty in ys:
                self.via("v3", x, ty)
        for net, x in export.items():
            ty = ty_of(net, last)
            self.rect("m2", x - 0.10, ty - 0.145, x + 0.10, block_top)
            self.via("v2", x, ty)
            # pin marker for the parent, and a label for LVS
            self.top.shapes(LY["text"]).insert(pya.DText("pin:" + net, x, block_top - 0.1))
            self.rect("m3pin", x - 0.065, ty - 0.065, x + 0.065, ty + 0.065)
            self.top.shapes(LY["m3txt"]).insert(pya.DText(net, x, ty))
        merge_duplicate_proxies()
        out = os.path.join(HERE, self.name + ".gds")
        layout.write(out)
        box = self.top.dbbox()
        m3 = sum((hi - lo) for t in track for _, lo, hi in t.values())
        print(f"build_blocks: wrote {out}: {box.width():.1f} x {box.height():.1f} um, "
              f"{sum(len(row['ports']) for row in rows)} pin connections, "
              f"{sum(len(t) for t in track)} trunks ({m3:.0f} um of Metal3), {len(riser)} risers")


# ------------------------------------------------------------------ blocks --

def inv(a, y, vdd="vdd", vss="vss"):
    return ("sg13cmos5l_inv_1", {"A": a, "Y": y, "VDD": vdd, "VSS": vss})


def invlvw(a, y):
    return leaf("invlvw", [("vdd", 0.50, 2.03), ("vss", 1.115, 0.43), (a, 2.00, 1.23), (y, 2.48, 1.88)],
                well="vdd")


def dff_c2mos():
    b = Block("dff_c2mos", ["d", "clk", "q", "qb", "vdd", "vss"], children=["invlvw"])
    b.add(stdcells(LV_LIB, [inv("clk", "clkb"), inv("clkb", "clki")]), "XI0 XI9")
    b.add(tgate(0.6, 1.2, "d", "net1", "clkb", "clki", "vdd"), "MT1")
    b.add(tgate(0.3, 0.6, "net4", "net1", "clki", "clkb", "vdd"), "MT2")
    b.add(stdcells(LV_LIB, [inv("net1", "net2")]), "XI1")
    b.add(invlvw("net2", "net4"), "XI2")
    b.add(tgate(0.6, 1.2, "net2", "net3", "clki", "clkb", "vdd"), "MT3")
    b.add(tgate(0.3, 0.6, "net5", "net3", "clkb", "clki", "vdd"), "MT4")
    b.add(stdcells(LV_LIB, [inv("net3", "net6")]), "XI3")
    b.add(invlvw("net6", "net5"), "XI4")
    b.add(stdcells(LV_LIB, [inv("net6", "qb"), inv("qb", "q")]), "XI5 XI6")
    b.route()


def level_shifter_up():
    b = Block("level_shifter_up", ["in", "q_h", "qb_h", "vddl", "vddh", "vss"])
    b.add(stdcells(LV_LIB, [inv("in", "net3", "vddl")]), "XI")
    b.add(lv_mos("sg13_lv_nmos", 1.0, 0.13, "net1", "in", "vss"), "MN1")
    b.add(lv_mos("sg13_lv_nmos", 1.0, 0.13, "net2", "net3", "vss"), "MN2")
    b.add(hv_mos("sg13_hv_nmos", 1.5, 0.45, "qb_h", "vddl", "net1", "vss"), "MC1")
    b.add(hv_mos("sg13_hv_nmos", 1.5, 0.45, "q_h", "vddl", "net2", "vss"), "MC2")
    b.add(hv_mos("sg13_hv_pmos", 0.5, 1.6, "qb_h", "q_h", "vddh", "vddh"), "MP1")
    b.add(hv_mos("sg13_hv_pmos", 0.5, 1.6, "q_h", "qb_h", "vddh", "vddh"), "MP2")
    b.route()


def divider_16():
    b = Block("divider_16", ["in", "out", "vdd", "vss"], children=["dff_c2mos"])
    b.add(stdcells(LV_LIB, [inv("in", "net1"), inv("net1", "net2")]), "XB1 XB2")
    clk = "net2"
    per_row = int(globals().get("per_row", 2))      # -rd per_row=1|2|4
    for i, (qb, q) in enumerate((("net3", "net4"), ("net5", "net6"), ("net7", "net8"), ("net9", "out"))):
        if i and i % per_row == 0:
            b.end_row()
        b.add(child("dff_c2mos", {"d": qb, "clk": clk, "q": q, "qb": qb, "vdd": "vdd", "vss": "vss"},
                    well="vdd"), f"X{i + 1}")
        clk = q
    b.route()


def delay_2ns():
    b = Block("delay_2ns", ["a", "y", "vdd", "vss"])
    nets = ["a", "net1", "net2", "net3", "y"]
    for i in range(4):
        b.add(stdcells(LV_LIB, [inv(nets[i], nets[i + 1])]), f"X{i + 1}")
        # MOS capacitor: gate on the node, source/drain on vss
        b.add(lv_mos("sg13_lv_nmos", 3.2 if i == 3 else 7.4, 6.0, "vss", nets[i + 1], "vss"), f"MC{i + 1}")
    b.route()


def muxlv():
    b = Block("muxlv", ["in0", "in1", "sel", "out", "vdd", "vss"])
    b.add(stdcells(LV_LIB, [inv("sel", "net1")]), "XI")
    b.add(tgate(1.0, 2.0, "in0", "out", "net1", "sel", "vdd"), "MT0")
    b.add(tgate(1.0, 2.0, "in1", "out", "sel", "net1", "vdd"), "MT1")
    b.route()


def muxhv():
    b = Block("muxhv", ["in0", "in1", "sel", "selb", "out", "vdd", "vss"])
    b.add(hv_mos("sg13_hv_nmos", 1.5, 0.45, "out", "selb", "in0", "vss"), "MT0N")
    b.add(hv_mos("sg13_hv_nmos", 1.5, 0.45, "out", "sel", "in1", "vss"), "MT1N")
    b.add(hv_mos("sg13_hv_pmos", 3.0, 0.45, "out", "sel", "in0", "vdd"), "MT0P")
    b.add(hv_mos("sg13_hv_pmos", 3.0, 0.45, "out", "selb", "in1", "vdd"), "MT1P")
    b.route()


def schmlv(a, y):
    return leaf("schmlv", [("vddl", 2.60, 6.10), ("vss", 1.25, 0.65), (a, 0.52, 2.43), (y, 5.70, 2.50)],
                well="vddl")


def bidir_channel():
    pins = ["a_pad", "b_pad", "dir", "oe_n", "en", "tm", "ring_div", "vddl", "vddh", "vss"]
    children = ["schmlv", "muxlv", "muxhv", "delay_2ns", "level_shifter_up", "divider_16"]
    for c in children:
        gds_cell(c)
    L, H = "vddl", "vddh"

    def lv(name, **pins):
        return ("sg13cmos5l_" + name, dict(pins, VDD=L, VSS="vss"))

    def hv(name, **pins):
        return ("sg13g2_hv_" + name, dict(pins, VDD=H, VSS="vss"))

    items = [
        (child("divider_16", {"in": "z_l", "out": "ring_div", "vdd": L, "vss": "vss"}, well=L), "XDV"),
        # direction/enable logic
        (stdcells(LV_LIB, [
            lv("inv_1", A="dir", Y="net1"), lv("or2_1", A="net1", B="tm", X="net2"),
            lv("and3_1", A="net2", B="oe", C="en", X="eur"), lv("and2_1", A="eur", B="net3", X="en_up"),
            lv("inv_1", A="oe_n", Y="oe"), lv("or2_1", A="dir", B="tm", X="net4"),
            lv("and3_1", A="net4", B="oe", C="en", X="ear"), lv("and2_1", A="ear", B="net5", X="en_a"),
            lv("inv_1", A="en_a", Y="en_ab")]), "XU1 XO1 XU3 XU5 XU2 XO2 XU6 XU8 XU9"),
        (child("delay_2ns", {"a": "eur", "y": "net3", "vdd": L, "vss": "vss"}, well=L), "XU4"),
        (child("delay_2ns", {"a": "ear", "y": "net5", "vdd": L, "vss": "vss"}, well=L), "XU7"),
        # 1.2 V side of the data path and the 1.2 V pad driver
        (schmlv("a_pad", "net6"), "XRX"),
        (child("muxlv", {"in0": "net7", "in1": "z_l", "sel": "tm", "out": "net8", "vdd": L, "vss": "vss"},
               well=L), "XM1"),
        (stdcells(LV_LIB, [lv("inv_1", A="net6", Y="net7"), lv("nand2_1", A="net8", B="en_up", Y="a_nb"),
                           lv("inv_1", A="a_nb", Y="net9"), lv("nand2_1", A="net21", B="en_a", Y="z_l"),
                           lv("nand2_1", A="z_l", B="en_a", Y="net22"),
                           lv("nor2_1", A="z_l", B="en_ab", Y="net23")]), "XRB XG1 XG2 XPK XA1 XA2"),
        (schmlv("net20", "net21"), "XS2"),
        (mos_fingers("sg13_lv_pmos", 24.0, 0.13, 4, "a_pad", "net22", L, L), "MPA"),
        (mos_fingers("sg13_lv_nmos", 12.0, 0.13, 2, "a_pad", "net23", "vss"), "MNA"),
        # data level shifter, 3.3 V pre-driver, 3.3 V receive path
        (lv_mos("sg13_lv_nmos", 2.0, 0.13, "net11", "net9", "vss"), "MN1"),
        (lv_mos("sg13_lv_nmos", 2.0, 0.13, "net13", "a_nb", "vss"), "MN2"),
        (hv_mos("sg13_hv_nmos", 3.0, 0.45, "net10", L, "net11", "vss"), "MN3"),
        (hv_mos("sg13_hv_nmos", 3.0, 0.45, "net12", L, "net13", "vss"), "MN4"),
        (hv_mos("sg13_hv_nmos", 0.5, 0.45, "net12", "enb_h", "vss", "vss"), "MN5"),
        (hv_mos("sg13_hv_pmos", 0.8, 0.8, "net10", "net12", H, H), "MP1"),
        (hv_mos("sg13_hv_pmos", 0.8, 0.8, "net12", "net10", H, H), "MP2"),
        (stdcells(HV_LIB, [hv("inv_1", A="net12", Y="net14"), hv("inv_2", A="net14", Y="z_h"),
                           hv("nand2_2", A="z_h", B="en_b_h", Y="net15"),
                           hv("nor2_2", A="z_h", B="enb_b_h", Y="net16")]), "XH1 XH2 XD1 XD2"),
        (rppd(1.0, 0.5, "b_pad", "net17"), "RSER"),
        (hv_mos("sg13_hv_nmos", 1.0, 0.45, "net18", "net17", "vss", "vss"), "MN7"),
        (hv_mos("sg13_hv_pmos", 1.5, 0.45, "net18", "net17", H, H), "MP6"),
        (child("muxhv", {"in0": "net18", "in1": "z_h", "sel": "tm_h", "selb": "tmb_h", "out": "net19",
                         "vdd": H, "vss": "vss"}, well=H), "XM2"),
        (hv_mos("sg13_hv_nmos", 0.8, 0.45, "net20", "net19", "vss", "vss"), "MN9"),
        (hv_mos("sg13_hv_pmos", 1.0, 0.45, "net20", "net19", L, L), "MP8"),
        # 3.3 V pad driver: one multi-finger device each
        (mos_fingers("sg13_hv_nmos", 48.0, 0.45, 4, "b_pad", "net16", "vss", "vss"), "MND"),
        (mos_fingers("sg13_hv_pmos", 96.0, 0.45, 8, "b_pad", "net15", H, H), "MPD"),
    ]
    for inst, i, q, qb in (("XL2", "en", "en_h", "enb_h"), ("XL3", "tm", "tm_h", "tmb_h"),
                           ("XL1", "en_up", "en_b_h", "enb_b_h")):
        items.append((child("level_shifter_up",
                            {"in": i, "q_h": q, "qb_h": qb, "vddl": L, "vddh": H, "vss": "vss"}), inst))
    # try a range of row widths and keep the smallest bounding box
    best = None
    for width in range(40, 131, 2):
        b = Block("bidir_channel", pins)
        b.pack(items, width)
        w, h = b.route(dry=True)
        if best is None or w * h < best[0]:
            best = (w * h, width)
    print(f"build_blocks: row width {best[1]} um gives the smallest area")
    b = Block("bidir_channel", pins)
    b.pack(items, best[1])
    b.route()


# ---------------------------------------------------------------- slot top --

TOP = "sg13cmos5l_bidir_level_shifter"
TEMPLATE = os.path.join(HERE, "floorplan", "chipalooza_template_small_analog.gds")
# Which template pin each channel pin goes to. Channel 0 is the one on pads.
CHANNELS = [
    # (x of the channel's left edge, {channel pin: template pin or None})
    (413.47, dict(a_pad="analog_0", b_pad="analog_1", dir="ui_in[0]", ring_div="uo_out[0]")),
    (122.0, dict(a_pad=None, b_pad=None, dir="ui_in[1]", ring_div="uo_out[1]")),
    (207.0, dict(a_pad=None, b_pad=None, dir="ui_in[2]", ring_div="uo_out[2]")),
    (292.0, dict(a_pad=None, b_pad=None, dir="ui_in[3]", ring_div="uo_out[3]")),
]
SHARED = dict(oe_n="ui_in[4]", en="ui_in[5]", tm="ui_in[6]", vddl="VPWR", vddh="VAPWR", vss="VGND")


def slot_top():
    """Four channels inside the Chipalooza `small` analog slot.

    The template's shapes are kept as they are: Metal3 signal pins on the
    west edge, Metal2 analog pins on the south edge, Metal4 power straps from
    bottom to top, and the PR boundary. The channels sit clear of the straps
    and of the west edge, upside down, so their pins face a routing channel
    along the south edge:
      - signals: Metal3 trunks to a Metal2 column next to the west edge, and
        from there to their pin,
      - supplies: 1 um Metal3 trunks under the straps, joined to them by Via3,
      - channel 0's pads: Metal2 straight down to the analog pins.
    """
    ci = gds_cell("bidir_channel")
    chan = layout.cell(ci)
    height = chan.dbbox().height()
    pin_x = {s.text.string[4:]: s.text.x * layout.dbu
             for s in chan.shapes(LY["text"]).each() if s.is_text() and s.text.string.startswith("pin:")}

    tpl = pya.Layout()
    tpl.read(TEMPLATE)
    src = tpl.top_cell()
    top = layout.create_cell(TOP)
    pins, straps, labels = {}, {}, []
    for li in tpl.layer_indexes():
        info = tpl.get_info(li)
        dst = layout.layer(info.layer, info.datatype)
        for sh in src.shapes(li).each():
            top.shapes(dst).insert(sh)
            if sh.is_text():
                pins[sh.text.string] = (sh.text.x * tpl.dbu, sh.text.y * tpl.dbu)
                labels.append((sh.text.string, pya.DPoint(sh.text.x * tpl.dbu, sh.text.y * tpl.dbu)))
    for li in tpl.layer_indexes():
        if (tpl.get_info(li).layer, tpl.get_info(li).datatype) == (50, 0):
            for sh in src.shapes(li).each():
                b = sh.dbbox()
                name = [n for n, pt in labels if b.contains(pt)][0]
                straps.setdefault(name, []).append(b)

    def rect(layer, x1, y1, x2, y2):
        top.shapes(LY[layer]).insert(pya.DBox(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)))

    def via(layer, x, y):
        rect(layer, x - 0.095, y - 0.095, x + 0.095, y + 0.095)

    YC = 16.0                                 # the channels' pin edge
    stubs = {}                                # template pin -> [stub x]
    for i, (x0, nets) in enumerate(CHANNELS):
        top.insert(pya.DCellInstArray(ci, pya.DTrans(pya.DTrans.M0, x0, YC + height)))
        top.shapes(LY["text"]).insert(pya.DText(f"XCH{i}", x0, YC + height + 0.3))
        for pin, target in dict(SHARED, **nets).items():
            if target:
                stubs.setdefault(target, []).append(r5(x0 + pin_x[pin]))

    # supplies: wide Metal3 trunks that pass under both strap groups
    for k, net in enumerate(("VPWR", "VGND", "VAPWR")):
        ty = 10.6 + 1.6 * k
        xs = stubs.pop(net) + [b.left for b in straps[net]] + [b.right for b in straps[net]]
        rect("m3", min(xs) - 0.3, ty - 0.5, max(xs) + 0.3, ty + 0.5)
        for x in [x for x in xs if not any(b.left <= x <= b.right for b in straps[net])]:
            rect("m2", x - 0.10, ty - 0.40, x + 0.10, YC + 0.3)
            for dy in (-0.25, 0.25):
                via("v2", x, ty + dy)
        for b in straps[net]:
            x = r5(b.left + 0.4)          # the template's second strap group is off grid
            while x <= b.right - 0.4 + 1e-6:
                for dy in (-0.25, 0.25):
                    via("v3", x, ty + dy)
                x = r5(x + 0.5)

    # channel 0's pads: Metal2 down to the analog pins on the south edge
    for level, net in enumerate(("analog_0", "analog_1")):
        (x,), (px, py) = stubs.pop(net), pins[net]
        jog = 2.0 + 1.5 * level
        if abs(x - px) < 0.4:
            rect("m2", x - 0.10, 0.5, x + 0.10, YC + 0.3)
        else:
            rect("m2", x - 0.10, jog - 0.5, x + 0.10, YC + 0.3)
            rect("m2", min(x, px) - 0.5, jog - 0.5, max(x, px) + 0.5, jog + 0.5)
            rect("m2", px - 0.5, 0.0, px + 0.5, jog + 0.5)

    # signals: one Metal3 trunk each, a Metal2 column by the west edge, and a
    # short Metal3 stub from the column to the pin
    for k, net in enumerate(sorted(stubs, key=lambda n: -pins[n][1])):
        ty, col = r5(5.0 + TRACK * k), r5(1.5 + PITCH * k)
        px, py = pins[net]
        rect("m3", col - 0.145, ty - 0.10, max(stubs[net]) + 0.145, ty + 0.10)
        for x in stubs[net]:
            rect("m2", x - 0.10, ty - 0.145, x + 0.10, YC + 0.3)
            via("v2", x, ty)
        via("v2", col, ty)
        rect("m2", col - 0.10, min(ty, py) - 0.145, col + 0.10, max(ty, py) + 0.145)
        via("v2", col, py)
        rect("m3", px - 0.2, py - 0.10, col + 0.145, py + 0.10)

    merge_duplicate_proxies()
    out = os.path.join(HERE, TOP + ".gds")
    layout.write(out)
    box = top.dbbox()
    print(f"build_blocks: wrote {out}: {box.width():.1f} x {box.height():.1f} um, "
          f"{len(CHANNELS)} channels")


BLOCKS = {f.__name__: f for f in (dff_c2mos, level_shifter_up, divider_16, delay_2ns, muxlv, muxhv,
                                  bidir_channel, slot_top)}
name = globals().get("block")
if name not in BLOCKS:
    fail("usage: klayout -zz -r build_blocks.py -rd block=<" + "|".join(BLOCKS) + ">")
BLOCKS[name]()
