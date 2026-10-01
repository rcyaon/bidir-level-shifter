# Place and route the blocks above the leaf cells.
#
# Each block is built as one or more rows of components with a routing
# channel above every row:
#   - a component is a PDK standard cell (or a run of abutting ones), a leaf
#     cell from <leaf>.gds, a child block, or one or two MOSFET PCells with
#     their contacts and tap,
#   - every pin gets a vertical Metal2 stub up into the channel above its row,
#   - every net gets a horizontal Metal3 trunk in each channel it has pins in,
#   - nets that span rows, and the block's own pins, use Metal2 risers in a
#     strip to the right of the rows. A block's pins end as Metal2 stubs on
#     its top edge so the parent can pick them up the same way.
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
    m3pin=(30, 2), m3txt=(30, 25), nwell=(31, 0), text=(63, 0)).items()}


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
    return [s.dbbox() for s in layout.cell(ci).shapes(LY[layer]).each()]


class Comp:
    """Shapes, sub-instances and ports of one component, in local coordinates.

    A port is (net, via_x, via_y, stub_x, kind): kind "v1" gets a Via1 with
    its Metal1 pad at the via point, kind "m2" is Metal2 already (a child
    block's pin on its top edge). stub_x differs from via_x when the stub is
    jogged sideways on Metal2 to keep the stub pitch.
    """

    def __init__(self, margin=0.7):
        self.shapes, self.insts, self.ports, self.vias = [], [], [], []
        self.margin = margin
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
    c = Comp(margin=2.0 if lib_name == HV_LIB else 0.7)
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


def leaf(name, ports):
    """A leaf cell from <name>.gds with hand-picked via points on its pins."""
    c = Comp()
    c.inst(gds_cell(name))
    for net, x, y in ports:
        c.port(net, x, y)
    return c


def child(name, nets):
    """A child block built by this script: pins are Metal2 on its top edge."""
    c = Comp(margin=1.0)
    ci = gds_cell(name)
    c.inst(ci)
    top = layout.cell(ci).dbbox().top
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
    c = Comp()
    name = "pmos" if "pmos" in model else "nmos"
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
    c = Comp()
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
    c = Comp(margin=2.0 if "pmos" in model else 0.7)
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
        self.top = layout.create_cell(name)
        self.rows = []            # [[(net, via_x, via_y, stub_x, kind)], ...] absolute
        self.y = 0.0              # bottom of the row being filled
        self.row_ports, self.row_top, self.x, self.prev_margin = [], 0.0, 0.0, 0.0
        self.width = 0.0
        self.channels = []        # [(y_bottom_of_channel, ports)]

    def shape(self, layer, b):
        self.top.shapes(LY[layer]).insert(b)

    def rect(self, layer, x1, y1, x2, y2):
        self.shape(layer, pya.DBox(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)))

    def add(self, comp, label=None):
        gap = max(comp.margin, self.prev_margin) if self.row_ports or self.x else 0.0
        dx = r5(self.x + gap - comp.bbox.left)
        dy = r5(self.y - comp.bbox.bottom)
        taken = [p[3] for p in self.row_ports]
        while any(abs(dx + p[3] - t) < PITCH - 1e-6 for p in comp.ports for t in taken):
            dx = r5(dx + 0.005)
        for ci, ix, iy in comp.insts:
            self.top.insert(pya.DCellInstArray(ci, pya.DTrans(pya.DVector(dx + ix, dy + iy))))
        for layer, b in comp.shapes:
            self.shape(layer, b.moved(dx, dy))
        for net, vx, vy, sx, kind in comp.ports:
            self.row_ports.append((net, r5(vx + dx), r5(vy + dy), r5(sx + dx), kind))
        for vx, vy in comp.vias:
            self.via1(r5(vx + dx), r5(vy + dy))
        if label:
            self.top.shapes(LY["text"]).insert(
                pya.DText(label, comp.bbox.left + dx, comp.bbox.top + dy + 0.05))
        self.x = comp.bbox.right + dx
        self.prev_margin = comp.margin
        self.row_top = max(self.row_top, comp.bbox.top + dy)
        self.width = max(self.width, self.x)

    def end_row(self):
        """Close the current row; the next one starts above its channel."""
        nets = sorted({p[0] for p in self.row_ports})
        y0 = r5(self.row_top + 0.60)
        self.channels.append((y0, self.row_ports))
        self.y = r5(y0 + len(nets) * TRACK + 1.0)
        self.row_ports, self.row_top, self.x, self.prev_margin = [], self.y, 0.0, 0.0

    def via1(self, x, y):
        self.rect("v1", x - 0.095, y - 0.095, x + 0.095, y + 0.095)
        self.rect("m1", x - 0.105, y - 0.145, x + 0.105, y + 0.145)

    def via2(self, x, y):
        self.rect("v2", x - 0.095, y - 0.095, x + 0.095, y + 0.095)

    def route(self):
        if self.row_ports:
            self.end_row()
        riser = {}                                  # net -> riser/export x
        multi = {}
        for _, ports in self.channels:
            for net in {p[0] for p in ports}:
                multi[net] = multi.get(net, 0) + 1
        x_next = r5(self.width + 1.0)
        for net in sorted(multi):
            if multi[net] > 1 or net in self.pins:
                riser[net] = x_next
                x_next = r5(x_next + PITCH)
        trunk_y = {}                                # net -> [y per channel]
        for y0, ports in self.channels:
            spans = {}
            for net, vx, vy, sx, kind in ports:
                lo, hi = spans.get(net, (sx, sx))
                spans[net] = (min(lo, sx), max(hi, sx))
            for net in spans:
                if net in riser:
                    spans[net] = (min(spans[net][0], riser[net]), max(spans[net][1], riser[net]))
            # left-edge track assignment
            tracks = []
            for net in sorted(spans, key=lambda n: spans[n][0]):
                lo, hi = spans[net]
                hi = max(hi, lo + 0.75 - 0.29)
                for k, right in enumerate(tracks):
                    if lo - right >= 0.29 + 0.25:
                        break
                else:
                    tracks.append(None)
                    k = len(tracks) - 1
                tracks[k] = hi
                ty = r5(y0 + k * TRACK)
                trunk_y.setdefault(net, []).append(ty)
                self.rect("m3", lo - 0.145, ty - 0.10, hi + 0.145, ty + 0.10)
                for pnet, vx, vy, sx, kind in ports:
                    if pnet != net:
                        continue
                    if kind == "v1":
                        self.via1(vx, vy)
                        if abs(sx - vx) > 1e-6:
                            self.rect("m2", min(vx, sx) - 0.145, vy - 0.10,
                                      max(vx, sx) + 0.145, vy + 0.10)
                    self.rect("m2", sx - 0.10, vy - 0.145, sx + 0.10, ty + 0.145)
                    self.via2(sx, ty)
        block_top = r5(max(y0 + 0.2 for y0, _ in self.channels) +
                       max(len({p[0] for p in ports}) for _, ports in self.channels) * TRACK + 0.6)
        block_top = r5(max(block_top, max(max(v) for v in trunk_y.values()) + 0.9))
        for net, x in riser.items():
            ys = trunk_y[net]
            top = block_top if net in self.pins else max(ys) + 0.145
            self.rect("m2", x - 0.10, min(ys) - 0.145, x + 0.10, top)
            for ty in ys:
                self.via2(x, ty)
            if net in self.pins:
                # pin marker for the parent, and a label for LVS
                self.top.shapes(LY["text"]).insert(pya.DText("pin:" + net, x, block_top - 0.1))
                ty = max(ys)
                self.rect("m3pin", x - 0.065, ty - 0.065, x + 0.065, ty + 0.065)
                self.top.shapes(LY["m3txt"]).insert(pya.DText(net, x, ty))
        missing = [p for p in self.pins if p not in riser]
        if missing:
            fail(f"{self.name}: pins with no connection: {missing}")
        merge_duplicate_proxies()
        out = os.path.join(HERE, self.name + ".gds")
        layout.write(out)
        box = self.top.dbbox()
        print(f"build_blocks: wrote {out}: {box.width():.1f} x {box.height():.1f} um, "
              f"{sum(len(p) for _, p in self.channels)} pin connections")


# ------------------------------------------------------------------ blocks --

def inv(a, y, vdd="vdd", vss="vss"):
    return ("sg13cmos5l_inv_1", {"A": a, "Y": y, "VDD": vdd, "VSS": vss})


def invlvw(a, y):
    return leaf("invlvw", [("vdd", 0.50, 2.03), ("vss", 1.115, 0.43), (a, 2.00, 1.23), (y, 2.48, 1.88)])


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
    for i, (qb, q) in enumerate((("net3", "net4"), ("net5", "net6"), ("net7", "net8"), ("net9", "out"))):
        if i == 2:
            b.end_row()
        b.add(child("dff_c2mos", {"d": qb, "clk": clk, "q": q, "qb": qb, "vdd": "vdd", "vss": "vss"}),
              f"X{i + 1}")
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
    return leaf("schmlv", [("vddl", 2.60, 6.10), ("vss", 1.25, 0.65), (a, 0.52, 2.43), (y, 5.70, 2.50)])


def bidir_channel():
    b = Block("bidir_channel",
              ["a_pad", "b_pad", "dir", "oe_n", "en", "tm", "ring_div", "vddl", "vddh", "vss"],
              children=["schmlv", "muxlv", "muxhv", "delay_2ns", "level_shifter_up", "divider_16"])
    L, H = "vddl", "vddh"

    def lv(name, **pins):
        return ("sg13cmos5l_" + name, dict(pins, VDD=L, VSS="vss"))

    def hv(name, **pins):
        return ("sg13g2_hv_" + name, dict(pins, VDD=H, VSS="vss"))

    # row 1: direction/enable logic and the 1.2 V side of the data path
    b.add(stdcells(LV_LIB, [
        lv("inv_1", A="dir", Y="net1"), lv("or2_1", A="net1", B="tm", X="net2"),
        lv("and3_1", A="net2", B="oe", C="en", X="eur"), lv("and2_1", A="eur", B="net3", X="en_up"),
        lv("inv_1", A="oe_n", Y="oe"), lv("or2_1", A="dir", B="tm", X="net4"),
        lv("and3_1", A="net4", B="oe", C="en", X="ear"), lv("and2_1", A="ear", B="net5", X="en_a"),
        lv("inv_1", A="en_a", Y="en_ab")]), "XU1 XO1 XU3 XU5 XU2 XO2 XU6 XU8 XU9")
    b.add(schmlv("a_pad", "net6"), "XRX")
    b.add(stdcells(LV_LIB, [lv("inv_1", A="net6", Y="net7")]), "XRB")
    b.add(child("muxlv", {"in0": "net7", "in1": "z_l", "sel": "tm", "out": "net8", "vdd": L, "vss": "vss"}), "XM1")
    b.add(stdcells(LV_LIB, [lv("nand2_1", A="net8", B="en_up", Y="a_nb"), lv("inv_1", A="a_nb", Y="net9")]),
          "XG1 XG2")
    b.add(schmlv("net20", "net21"), "XS2")
    b.add(stdcells(LV_LIB, [lv("nand2_1", A="net21", B="en_a", Y="z_l"),
                            lv("nand2_1", A="z_l", B="en_a", Y="net22"),
                            lv("nor2_1", A="z_l", B="en_ab", Y="net23")]), "XPK XA1 XA2")
    for i in range(4):
        b.add(lv_mos("sg13_lv_pmos", 6.0, 0.13, "a_pad", "net22", L, L), f"MPA.{i + 1}")
    for i in range(2):
        b.add(lv_mos("sg13_lv_nmos", 6.0, 0.13, "a_pad", "net23", "vss"), f"MNA.{i + 1}")
    b.end_row()
    # row 2: break-before-make delays
    b.add(child("delay_2ns", {"a": "eur", "y": "net3", "vdd": L, "vss": "vss"}), "XU4")
    b.add(child("delay_2ns", {"a": "ear", "y": "net5", "vdd": L, "vss": "vss"}), "XU7")
    b.end_row()
    # row 3: level shifters for the enables
    for inst, i, q, qb in (("XL2", "en", "en_h", "enb_h"), ("XL3", "tm", "tm_h", "tmb_h"),
                           ("XL1", "en_up", "en_b_h", "enb_b_h")):
        b.add(child("level_shifter_up", {"in": i, "q_h": q, "qb_h": qb, "vddl": L, "vddh": H, "vss": "vss"}), inst)
    b.end_row()
    # row 4: data level shifter, 3.3 V pre-driver and the 3.3 V receive path
    b.add(lv_mos("sg13_lv_nmos", 2.0, 0.13, "net11", "net9", "vss"), "MN1")
    b.add(lv_mos("sg13_lv_nmos", 2.0, 0.13, "net13", "a_nb", "vss"), "MN2")
    b.add(hv_mos("sg13_hv_nmos", 3.0, 0.45, "net10", L, "net11", "vss"), "MN3")
    b.add(hv_mos("sg13_hv_nmos", 3.0, 0.45, "net12", L, "net13", "vss"), "MN4")
    b.add(hv_mos("sg13_hv_nmos", 0.5, 0.45, "net12", "enb_h", "vss", "vss"), "MN5")
    b.add(hv_mos("sg13_hv_pmos", 0.8, 0.8, "net10", "net12", H, H), "MP1")
    b.add(hv_mos("sg13_hv_pmos", 0.8, 0.8, "net12", "net10", H, H), "MP2")
    b.add(stdcells(HV_LIB, [hv("inv_1", A="net12", Y="net14"), hv("inv_2", A="net14", Y="z_h"),
                            hv("nand2_2", A="z_h", B="en_b_h", Y="net15"),
                            hv("nor2_2", A="z_h", B="enb_b_h", Y="net16")]), "XH1 XH2 XD1 XD2")
    b.add(rppd(1.0, 0.5, "b_pad", "net17"), "RSER")
    b.add(hv_mos("sg13_hv_nmos", 1.0, 0.45, "net18", "net17", "vss", "vss"), "MN7")
    b.add(hv_mos("sg13_hv_pmos", 1.5, 0.45, "net18", "net17", H, H), "MP6")
    b.add(child("muxhv", {"in0": "net18", "in1": "z_h", "sel": "tm_h", "selb": "tmb_h", "out": "net19",
                          "vdd": H, "vss": "vss"}), "XM2")
    b.add(hv_mos("sg13_hv_nmos", 0.8, 0.45, "net20", "net19", "vss", "vss"), "MN9")
    b.add(hv_mos("sg13_hv_pmos", 1.0, 0.45, "net20", "net19", L, L), "MP8")
    b.end_row()
    # row 5: 3.3 V pad driver
    for i in range(4):
        b.add(hv_mos("sg13_hv_nmos", 12.0, 0.45, "b_pad", "net16", "vss", "vss"), f"MND.{i + 1}")
    for i in range(8):
        b.add(hv_mos("sg13_hv_pmos", 12.0, 0.45, "b_pad", "net15", H, H), f"MPD.{i + 1}")
    b.end_row()
    # row 6: test-mode divider
    b.add(child("divider_16", {"in": "z_l", "out": "ring_div", "vdd": L, "vss": "vss"}), "XDV")
    b.route()


BLOCKS = {f.__name__: f for f in (dff_c2mos, level_shifter_up, divider_16, delay_2ns, muxlv, muxhv,
                                  bidir_channel)}
name = globals().get("block")
if name not in BLOCKS:
    fail("usage: klayout -zz -r build_blocks.py -rd block=<" + "|".join(BLOCKS) + ">")
BLOCKS[name]()
