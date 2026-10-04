# Place and route the blocks above the leaf cells.
#
# Each block is built as one or more rows of components with a routing
# channel above every row:
#   - a component is a PDK standard cell (or a run of abutting ones), a leaf
#     cell from <leaf>.gds, a child block, or a group of MOSFET PCells with
#     their contacts and one tap or guard ring,
#   - every pin gets a vertical Metal2 stub up into the channel above its row,
#   - every net gets a horizontal Metal3 trunk in each channel it has pins in,
#   - a net that spans rows gets one vertical Metal4 riser joining its
#     trunks, placed as close to its pins as possible. A block's pins end as
#     Metal2 stubs on its top edge so the parent can pick them up the same way.
# MOSFETs are grouped to keep them close: devices with a common net and the
# same size are fingers of one PCell and share that diffusion, HV devices of
# one type sit in one guard ring, and transmission gates share a well and tap.
# The result is correct by construction and checked with DRC/LVS. The routing
# channels are not optimised.
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
PITCH = 0.42          # Metal2 stub pitch: 0.20 wide, 0.22 space (at 0.21 magic
                      # merges two neighbouring Via1s into one contact)
TRACK = 0.42          # Metal3 trunk pitch
RAIL_W, RAIL_S = 1.0, 0.4    # Metal1 supply rails above every row
BUS_W, BUS_S = 1.2, 0.4      # Metal2 supply buses down both sides of a block
WIDE_W = 1.0                 # Metal2 width of a pad net's pin
VIA_P = 0.48                 # via pitch in an array (0.19 via, 0.29 space)
LV_LIB, HV_LIB = "sg13cmos5l_stdcell", "sg13cmos5l_stdcell_hv"

layout = pya.Layout()
layout.dbu = 0.001
layout.technology_name = TECH
LY = {n: layout.layer(*ld) for n, ld in dict(
    activ=(1, 0), poly=(5, 0), cont=(6, 0), m1=(8, 0), m1pin=(8, 2),
    m1txt=(8, 25), v1=(19, 0), m2=(10, 0), v2=(29, 0), m3=(30, 0),
    m3pin=(30, 2), m3txt=(30, 25), v3=(49, 0), m4=(50, 0), nwell=(31, 0),
    tgo=(44, 0), tv1=(125, 0), tm1=(126, 0), text=(63, 0)).items()}


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
    block's pin on its top edge), "m2w" is a child's WIDE_W wide pad pin and
    "bus" the top end of one of a child's supply buses. stub_x differs from
    via_x when the stub is jogged sideways on Metal2 to keep the stub pitch.
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
    if lib_name == HV_LIB:
        # the HV cells' n-well ends 0.24 past their tap; magic wants 0.62 (NW.e1)
        nw = lambda name: pya.DBox(pya.Region(lib_ly.cell(name).shapes(lib_ly.layer(31, 0))).bbox()) * layout.dbu
        first, last = nw(cells[0][0]), nw(cells[-1][0])
        c.box("nwell", first.left, first.top - 0.5, x - width + last.right, first.top + 0.38)
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
        if not s.is_text() or ":" not in s.text.string:
            continue
        kind, pin = s.text.string.split(":", 1)
        if kind in ("pin", "wpin", "bus"):
            c.port(nets[pin], s.text.x * layout.dbu, top, kind={"pin": "m2", "wpin": "m2w", "bus": "bus"}[kind])
    return c


def gate_contact(c, gx1, gx2, y_poly, up, net=None, via_x=None):
    """Poly pad with as many contacts as fit across gx1..gx2, under one
    Metal1 strip; returns the via point (the pad's centre, or `via_x`)."""
    gc = r5((gx1 + gx2) / 2)
    half = max(0.15, (gx2 - gx1) / 2)
    s = 1 if up else -1
    c.box("poly", gc - half, y_poly, gc + half, y_poly + s * 0.33)
    cy = r5(y_poly + s * 0.18)
    n = max(1, int((2 * half - 0.14 + 0.18) / 0.34 + 1e-6))
    if n == 1:
        c.box("cont", gc - 0.08, cy - 0.08, gc + 0.08, cy + 0.08)
        c.box("m1", gc - 0.15, cy - 0.16, gc + 0.15, cy + 0.16)
    else:
        x0 = r5(gc - (n - 1) * 0.17)
        for k in range(n):
            x = r5(x0 + k * 0.34)
            c.box("cont", x - 0.08, cy - 0.08, x + 0.08, cy + 0.08)
        # 0.26 tall: a strip of 0.3 or more would need the wide-metal spacing
        c.box("m1", x0 - 0.15, cy - 0.13, r5(x0 + (n - 1) * 0.34) + 0.15, cy + 0.13)
    vx = gc if via_x is None else via_x
    if net:
        c.port(net, vx, cy)
    return vx, cy


def chain_cell(model, w, l, nets):
    """PCell for a chain of MOSFETs that share their sources/drains.

    `nets` is [sd, gate, sd, gate, ..., sd]: one finger of width `w` per gate.
    Neighbouring fingers share one diffusion strip, whether they are fingers
    of one device or different devices. Returns (cell, terminals, gates).
    """
    hv, pm = "_hv_" in model, "pmos" in model
    ng = len(nets) // 2
    params = dict(model=model, w=f"{r5(w * ng):g}u", l=f"{l}u", ng=str(ng))
    if hv:
        params["guardRingType"] = "none"
    ci = pcell(("pmos" if pm else "nmos") + ("HV" if hv else ""), **params)
    polys = sorted(boxes(ci, "poly"), key=lambda b: b.left)
    terms = sorted([b for b in boxes(ci, "m1") if b.top <= polys[0].top], key=lambda b: b.left)
    if len(terms) != ng + 1 or len(polys) != ng:
        fail(f"{model} ng={ng}: unexpected PCell geometry")
    return ci, terms, polys


def add_ntap(c, x0, y0, net):
    tap = pcell("ntap1", w="0.78u", l="0.78u")
    c.inst(tap, x0, y0)
    c.port(net, r5(x0 + 0.39), r5(y0 + 0.39))
    well = None
    for ci, dx, dy in c.insts:
        for b in boxes(ci, "nwell"):
            well = b.moved(dx, dy) if well is None else well + b.moved(dx, dy)
    c.box("nwell", well.left, well.bottom, well.right, well.top)


def gates_above(c, terms, polys, nets, x=0.0, y=0.0):
    """Contact the gates of a chain at (x, y) above it; returns the right end.

    A gate of 0.45 um or longer has room for its own contact. Short gates
    are too close to the source/drain stubs for that: with one net they are
    joined by a poly bar with a row of contacts along it and the via at its
    left end, and two gates on different nets get a bar each, one to the left
    and one to the right.
    """
    top = y + polys[0].top
    if polys[0].width() >= 0.44:
        for p, net in zip(polys, nets):
            gate_contact(c, x + p.left, x + p.right, top, True, net)
        return x + terms[-1].right
    bar = r5(top - 0.03)
    x0, x1 = r5(x + terms[0].left - 0.50), r5(x + terms[-1].right + 0.50)
    if len(set(nets)) == 1:
        gate_contact(c, x0, r5(x + polys[-1].right), bar, True, nets[0], via_x=r5(x0 + 0.15))
        return x + terms[-1].right
    if len(nets) != 2:
        fail("more than two short gates on different nets in one chain")
    gate_contact(c, x0, r5(x + polys[0].right), bar, True, nets[0], via_x=r5(x0 + 0.15))
    gate_contact(c, r5(x + polys[1].left), x1, bar, True, nets[1], via_x=r5(x1 - 0.15))
    return x1


def lv_chain(model, w, l, nets, bulk=None):
    """LV MOSFETs sharing diffusion: `nets` as for chain_cell.

    Every source/drain strip is a port. A PMOS chain gets one ntap1 in its
    well, wired to `bulk`. An NMOS relies on the substrate ties of the
    standard cells and guard rings around it.
    """
    c = Comp(well=bulk if "pmos" in model else None)
    ci, terms, polys = chain_cell(model, w, l, nets)
    c.inst(ci)
    y1 = r5(min(0.145, w / 2))
    for i, t in enumerate(terms):
        c.port(nets[2 * i], r5(t.center().x), y1, top=w - 0.145)
    right = gates_above(c, terms, polys, nets[1::2])
    if "pmos" in model:
        add_ntap(c, r5(right + 0.30), 0.0, bulk)
    return c


def fingers(ng, d, g, s):
    """Net list of one device drawn as `ng` fingers: s g d g s ..."""
    nets = [s]
    for i in range(ng):
        nets += [g, s if i % 2 else d]
    return nets


def hv_row(model, devs, bulk):
    """HV MOSFETs of one type side by side in one guard ring.

    devs: [(w, l, nets)], each a chain as for chain_cell, so devices with a
    common net and the same size share diffusion; the others are an Activ
    space apart. The ring is the bulk tie (psub for NMOS, n-well for PMOS)
    and sits as close as the thick-oxide spacing allows.
    """
    pm = "pmos" in model
    c = Comp(well=bulk if pm else None)
    x, tgo = 0.0, pya.DBox()
    for w, l, nets in devs:
        ci, terms, polys = chain_cell(model, w, l, nets)
        c.inst(ci, x, 0.0)
        y1 = r5(min(0.145, w / 2))
        for i, t in enumerate(terms):
            c.port(nets[2 * i], r5(x + t.center().x), y1, top=w - 0.145)
        # neighbouring gates on one net share a poly bar and its contact row
        gates, k = nets[1::2], 0
        while k < len(polys):
            j = k
            while j + 1 < len(polys) and gates[j + 1] == gates[k]:
                j += 1
            gate_contact(c, x + polys[k].left, x + polys[j].right, polys[k].top, True, gates[k],
                         via_x=r5(x + polys[k].center().x))
            k = j + 1
        for b in boxes(ci, "tgo"):
            tgo += b.moved(x, 0.0)
        x = r5(x + terms[-1].right + 0.07 + 0.21)
    c.box("tgo", tgo.left, tgo.bottom, tgo.right, tgo.top)
    # ring: 0.30 wide, 0.27 from the thick oxide; the PCell is centred, so
    # its width and height have to be multiples of 10 nm
    d = 0.27 + 0.30
    xl, yb = r5(tgo.left - d), r5(tgo.bottom - d)
    rw, rh = [round((v + d - o) / 0.01 + 0.499) * 0.01 for v, o in ((tgo.right, xl), (tgo.top, yb))]
    ring = pcell("guard_ring", type="nwell" if pm else "psub", w=f"{rw:.2f}u", h=f"{rh:.2f}u")
    c.inst(ring, r5(xl + rw / 2), r5(yb + rh / 2))
    c.port(bulk, r5(xl + 0.15), r5(yb + rh - 0.15))
    return c


def tgate_pairs(pairs, vdd):
    """LV transmission gates in one well, NMOS below and PMOS above.

    pairs: [(t1, t2)], each t = (wn, wp, a, b, gn, gp) with t1's b being
    t2's a. Two gates of the same size share that diffusion; otherwise the
    two strips are joined in Metal1. Sources/drains are strapped from NMOS
    to PMOS in Metal1, PMOS gates are contacted above, NMOS gates below and
    brought out sideways. One ntap1 at the right end ties the well to `vdd`.
    """
    c = Comp(well=vdd)
    wn_max = max(t[0] for pair in pairs for t in pair)
    p0, yv, cy = r5(wn_max + 0.70), r5(wn_max + 0.35), -0.36
    x, last = 0.0, None

    def strap(t, dx, wp):
        c.box("m1", dx + t.left, 0.0, dx + t.right, p0 + wp)

    def n_gate(poly, dx, vx, net):
        gc, _ = gate_contact(c, dx + poly.left, dx + poly.right, poly.bottom, False)
        c.box("m1", vx - 0.105, cy - 0.145, gc, cy + 0.145)
        c.box("m1", vx + 0.105, cy - 0.145, gc, cy + 0.145)
        c.port(net, vx, cy)

    for t1, t2 in pairs:
        (wn, wp, a, m, gn1, gp1), (wn2, wp2, m2, b, gn2, gp2) = t1, t2
        if m != m2:
            fail("tgate_pairs: the two gates of a pair need a common net")
        if (wn, wp) == (wn2, wp2):
            n, terms, polys = chain_cell("sg13_lv_nmos", wn, 0.13, [a, gn1, m, gn2, b])
            p, p_terms, p_polys = chain_cell("sg13_lv_pmos", wp, 0.13, [a, gp1, m, gp2, b])
            first = r5(terms[0].left - 0.35 - PITCH)
            if last is not None:
                x = r5(last + PITCH - first)
            c.inst(n, x, 0.0)
            c.inst(p, x, p0)
            for t, net in zip(terms, (a, m, b)):
                strap(t, x, wp)
                c.port(net, r5(x + t.center().x), yv)
            x1 = gates_above(c, p_terms, p_polys, [gp1, gp2], x, p0)
            last = r5(x1 - 0.15 + PITCH)
            n_gate(polys[0], x, r5(x + first), gn1)
            n_gate(polys[1], x, last, gn2)
        else:
            cells = [(chain_cell("sg13_lv_nmos", t[0], 0.13, [0, 0, 0]),
                      chain_cell("sg13_lv_pmos", t[1], 0.13, [0, 0, 0])[0]) for t in (t1, t2)]
            terms, polys = cells[0][0][1], cells[0][0][2]
            pitch = r5(terms[-1].right + 0.07 + 0.21)       # one device plus an Activ space
            gc = polys[0].center().x
            first = r5(gc - 2 * PITCH)
            if last is not None:
                x = r5(last + PITCH - first)
            for k, (t, gn, gp) in enumerate(((t1, gn1, gp1), (t2, gn2, gp2))):
                dx = r5(x + k * pitch)
                c.inst(cells[k][0][0], dx, 0.0)
                c.inst(cells[k][1], dx, p0)
                for term in terms:
                    strap(term, dx, t[1])
                gate_contact(c, dx + polys[0].left, dx + polys[0].right, p0 + t[1] + 0.18, True, gp)
                vx = r5(dx + gc + (2 * k - 1) * 2 * PITCH)
                n_gate(polys[0], dx, vx, gn)
                last = vx
            # outer strips widened for a via clear of the gate stubs, inner ones joined
            c.box("m1", x + gc - PITCH - 0.105, yv - 0.145, x + terms[0].right, yv + 0.145)
            c.port(a, r5(x + gc - PITCH), yv)
            c.box("m1", x + terms[-1].left, yv - 0.145, x + pitch + terms[0].right, yv + 0.145)
            c.port(m, r5(x + (terms[-1].center().x + pitch + terms[0].center().x) / 2), yv)
            c.box("m1", x + pitch + terms[-1].left, yv - 0.145, x + pitch + gc + PITCH + 0.105, yv + 0.145)
            c.port(b, r5(x + pitch + gc + PITCH), yv)
    add_ntap(c, r5(last + PITCH - 0.39), p0, vdd)
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
    def __init__(self, name, pins, supplies=(), wide=(), ring=None, children=()):
        """`supplies` are routed on Metal1 rails and Metal2 buses instead of
        trunks; `wide` nets (pads) get a three-track trunk and a WIDE_W pin;
        `ring` is the supply a p-substrate guard ring around the block ties to.
        """
        # Read child layouts before anything else is created: their standard
        # cells come back as library proxies and are then shared, instead of
        # clashing by name with proxies made here first.
        for c in children:
            gds_cell(c)
        self.name, self.pins = name, pins
        self.supplies, self.wide, self.ring = list(supplies), set(wide), ring
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

    def stub_xs(self, port, dx=0.0):
        """x positions a port's Metal2 stub keeps the stub pitch from: a wide
        stub counts as three, so no thin stub fits beside it too closely."""
        net, _, _, sx, kind = port
        w = BUS_W if kind == "bus" else WIDE_W if kind == "m2w" and net in self.wide else 0.0
        x = sx + dx
        return [x] if not w else [x - (w / 2 - 0.05), x, x + (w / 2 - 0.05)]

    def add(self, comp, label=None):
        row = self.row
        gap = self.gap(self.prev, comp) if row["comps"] else 0.0
        dx = r5(self.x + gap - comp.bbox.left)
        dy = r5(-comp.bbox.bottom)
        taken = [x for p in row["ports"] for x in self.stub_xs(p)]
        while any(abs(x - t) < PITCH - 1e-6 for p in comp.ports for x in self.stub_xs(p, dx) for t in taken):
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

    def via_array(self, layer, x1, y1, x2, y2):
        """As many vias as fit in the box, 0.05 inside it."""
        nx = max(1, int((x2 - x1 - 0.29) / VIA_P + 1e-6) + 1)
        ny = max(1, int((y2 - y1 - 0.29) / VIA_P + 1e-6) + 1)
        cx, cy = (x1 + x2) / 2, (y1 + y2) / 2
        for i in range(nx):
            for j in range(ny):
                self.via(layer, r5(cx + (i - (nx - 1) / 2) * VIA_P), r5(cy + (j - (ny - 1) / 2) * VIA_P))

    @staticmethod
    def free_x(want, taken, blocked=(), lo=0.0, clear=PITCH):
        """Nearest x to `want` that keeps `clear` to `taken` and avoids `blocked`."""
        for k in range(0, 100000):
            for x in (r5(want + k * 0.05), r5(want - k * 0.05)):
                if x >= lo and all(abs(x - t) >= clear - 1e-6 for t in taken) and \
                        not any(a <= x <= b for a, b in blocked):
                    return x
        fail("no free column")

    def route(self, dry=False, write=True):
        """Route the block. With `dry`, only return (width, height); with
        `write` False, keep the cell in `layout` without writing a file.

        Supplies don't use the trunks: above every row each supply gets a
        RAIL_W Metal1 rail across the whole block, its pins reach it on short
        Metal2 stubs with two vias, and the rails of one supply are joined by
        a BUS_W Metal2 bus down each side of the block, which also leaves the
        block at its top edge.
        """
        self.end_row()
        rows, last = self.rows, len(self.rows) - 1
        sup = self.supplies
        in_rows = {}                                # signal net -> rows it has pins in
        for r, row in enumerate(rows):
            for p in row["ports"]:
                if p[0] not in sup:
                    in_rows.setdefault(p[0], set()).add(r)
        have = {p[0] for row in rows for p in row["ports"]}
        missing = [p for p in self.pins if p not in have]
        if missing:
            fail(f"{self.name}: pins with no connection: {missing}")
        signals = [p for p in self.pins if p not in sup]
        for net in signals:                         # pins leave through the top channel
            in_rows[net].add(last)

        # Metal4 risers for nets in more than one row, as close to their pins
        # as the columns already taken and any Metal4 in child blocks allow.
        riser, taken = {}, []
        for net in sorted(in_rows, key=lambda n: (-len(in_rows[n]), n)):
            if len(in_rows[net]) < 2:
                continue
            if net in self.wide:
                fail(f"{self.name}: wide net {net} has pins in more than one row")
            xs = sorted(p[3] for row in rows for p in row["ports"] if p[0] == net)
            crossed = range(min(in_rows[net]) + 1, max(in_rows[net]) + 1)
            blocked = [b for r in crossed for b in rows[r]["blocked"]]
            riser[net] = self.free_x(xs[len(xs) // 2], taken, blocked)
            taken.append(riser[net])
        # Metal2 stubs that take the block's pins from the top channel to its top edge
        export, taken = {}, [x for p in rows[last]["ports"] for x in self.stub_xs(p)]
        for net in sorted(signals, key=lambda n: n not in self.wide):
            xs = sorted(p[3] for p in rows[last]["ports"] if p[0] == net) or [riser[net]]
            wide = net in self.wide
            export[net] = self.free_x(xs[len(xs) // 2], taken, lo=0.6 if wide else 0.0,
                                      clear=WIDE_W / 2 + 0.36 if wide else PITCH)
            taken += [export[net]] + ([export[net] - 0.45, export[net] + 0.45] if wide else [])

        # left-edge track assignment per channel, then the row positions;
        # a wide net gets three tracks of its own above the others
        track = []                                  # per row: {net: (track, lo, hi)}
        for r, row in enumerate(rows):
            spans = {}
            for net, vx, vy, sx, kind in row["ports"]:
                if net not in sup:
                    spans.setdefault(net, []).append(sx)
            for net in in_rows:
                if r in in_rows[net]:
                    if net in riser:
                        spans.setdefault(net, []).append(riser[net])
                    if r == last and net in export:
                        spans.setdefault(net, []).append(export[net])
            used, assigned = [], {}
            for net in sorted(spans, key=lambda n: (n in self.wide, min(spans[n]))):
                lo, hi = min(spans[net]), max(spans[net])
                hi = max(hi, lo + 0.75 - 0.29)      # minimum Metal3 area
                if net in self.wide:
                    k = len(used)
                    used += [1e9] * 3
                    assigned[net] = (k, lo - 0.4, hi + 0.4)
                    continue
                for k, right in enumerate(used):
                    if lo - right >= 0.29 + 0.25:
                        break
                else:
                    used.append(None)
                    k = len(used) - 1
                used[k] = hi
                assigned[net] = (k, lo, hi)
            track.append(assigned)
        rails_h = (0.5 + len(sup) * RAIL_W + (len(sup) - 1) * RAIL_S + 0.5) if sup else 0.0
        y_row, y_chan, y = [], [], 0.0
        for r, row in enumerate(rows):
            y_row.append(y)
            y_chan.append(r5(y + row["top"] + 0.60))
            n = max([1] + [k + (3 if net in self.wide else 1) for net, (k, _, _) in track[r].items()])
            # 1.9 um at least, for wells on different nets in neighbouring rows
            y = r5(max(y_chan[r] + (n - 1) * TRACK + 0.10 + 0.60, y_row[r] + row["top"] + 1.9,
                       y_row[r] + row["top"] + rails_h))
        rail_y = lambda r, k: r5(y_row[r] + rows[r]["top"] + 0.5 + k * (RAIL_W + RAIL_S) + RAIL_W / 2)
        ring_m = 2.0 if self.ring else 0.0          # room for the guard ring
        block_top = r5(y + 0.20 + ring_m)
        right = r5(max([c[0].bbox.right + c[1] for row in rows for c in row["comps"]] +
                       list(riser.values()) + [x + (0.5 if n in self.wide else 0) for n, x in export.items()]) + 0.3)
        bus_x = {}                                  # supply -> (left bus x, right bus x)
        for k, net in enumerate(sup):
            d = r5(0.6 + BUS_W / 2 + k * (BUS_W + BUS_S))
            bus_x[net] = (-d, r5(right + d))
        x_lo = -(0.6 + len(sup) * BUS_W + (len(sup) - 1) * BUS_S) if sup else 0.0
        x_hi = right - x_lo if sup else right
        if dry:
            return x_hi - x_lo + 2 * ring_m, block_top
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
            # supply rails, and every supply pin of the row up to its rail
            for k, net in enumerate(sup):
                ry = rail_y(r, k)
                self.rect("m1", x_lo, ry - RAIL_W / 2, x_hi, ry + RAIL_W / 2)
                for pnet, vx, vy, sx, kind in row["ports"]:
                    if pnet != net:
                        continue
                    vy = r5(y0 + vy)
                    if kind == "bus":
                        self.rect("m2", sx - BUS_W / 2, vy - 0.3, sx + BUS_W / 2, ry + RAIL_W / 2)
                        self.via_array("v1", sx - BUS_W / 2, ry - RAIL_W / 2, sx + BUS_W / 2, ry + RAIL_W / 2)
                        continue
                    if kind == "v1":
                        self.via("v1", vx, vy)
                        self.rect("m1", vx - 0.105, vy - 0.145, vx + 0.105, vy + 0.145)
                        if abs(sx - vx) > 1e-6:
                            self.rect("m2", min(vx, sx) - 0.145, vy - 0.10,
                                      max(vx, sx) + 0.145, vy + 0.10)
                    self.rect("m2", sx - 0.10, vy - 0.145, sx + 0.10, ry + 0.24 + 0.145)
                    for d in (-0.24, 0.24):
                        self.via("v1", sx, ry + d)
            for net, (k, lo, hi) in track[r].items():
                ty = r5(y_chan[r] + k * TRACK)
                wide = net in self.wide
                self.rect("m3", lo - 0.145, ty - 0.10, hi + 0.145, ty + (2 * TRACK if wide else 0) + 0.10)
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
                    if kind == "m2w" and wide:
                        self.rect("m2", sx - WIDE_W / 2, vy - 0.3, sx + WIDE_W / 2, ty + 2 * TRACK + 0.10)
                        self.via_array("v2", sx - WIDE_W / 2, ty - 0.10, sx + WIDE_W / 2, ty + 2 * TRACK + 0.10)
                        continue
                    self.rect("m2", sx - 0.10, vy - 0.145, sx + 0.10, ty + (2 * TRACK if wide else 0) + 0.145)
                    for j in range(3 if wide else 1):
                        self.via("v2", sx, ty + j * TRACK)
        ty_of = lambda net, r: r5(y_chan[r] + track[r][net][0] * TRACK)
        for net, x in riser.items():
            ys = [ty_of(net, r) for r in sorted(in_rows[net])]
            self.rect("m4", x - 0.10, ys[0] - 0.145, x + 0.10, ys[-1] + 0.145)
            for ty in ys:
                self.via("v3", x, ty)
        for net, x in export.items():
            ty = ty_of(net, last)
            if net in self.wide:
                self.rect("m2", x - WIDE_W / 2, ty - 0.10, x + WIDE_W / 2, block_top)
                self.via_array("v2", x - WIDE_W / 2, ty - 0.10, x + WIDE_W / 2, ty + 2 * TRACK + 0.10)
                tag = "wpin:"
            else:
                self.rect("m2", x - 0.10, ty - 0.145, x + 0.10, block_top)
                self.via("v2", x, ty)
                tag = "pin:"
            # pin marker for the parent, and a label for LVS
            self.top.shapes(LY["text"]).insert(pya.DText(tag + net, x, block_top - 0.1))
            self.rect("m3pin", x - 0.065, ty - 0.065, x + 0.065, ty + 0.065)
            self.top.shapes(LY["m3txt"]).insert(pya.DText(net, x, ty))
        # supply buses down both sides, joined to every rail of their supply
        for k, net in enumerate(sup):
            for x in bus_x[net]:
                self.rect("m2", x - BUS_W / 2, rail_y(0, k) - RAIL_W / 2, x + BUS_W / 2, block_top)
                for r in range(len(rows)):
                    ry = rail_y(r, k)
                    self.via_array("v1", x - BUS_W / 2, ry - RAIL_W / 2, x + BUS_W / 2, ry + RAIL_W / 2)
                self.top.shapes(LY["text"]).insert(pya.DText("bus:" + net, x, block_top - 0.1))
            ry = rail_y(last, k)
            self.rect("m1pin", x_lo + 0.2, ry - 0.2, x_lo + 0.6, ry + 0.2)
            self.top.shapes(LY["m1txt"]).insert(pya.DText(net, x_lo + 0.4, ry))
        if self.ring:
            # p-substrate guard ring around everything, tied to the ring
            # supply's rails, which run out to it on both sides
            x1, y1 = r5(x_lo - ring_m + 0.3), -ring_m + 0.3
            x2, y2 = r5(x_hi + ring_m - 0.3), r5(y + ring_m - 0.6)
            rw, rh = [round((b - a) / 0.01 + 0.499) * 0.01 for a, b in ((x1, x2), (y1, y2))]
            ring = pcell("guard_ring", type="psub", w=f"{rw:.2f}u", h=f"{rh:.2f}u")
            self.top.insert(pya.DCellInstArray(ring, pya.DTrans(pya.DVector(r5(x1 + rw / 2), r5(y1 + rh / 2)))))
            k = sup.index(self.ring)
            for r in range(len(rows)):
                ry = rail_y(r, k)
                self.rect("m1", x1 + 0.05, ry - RAIL_W / 2, x_lo, ry + RAIL_W / 2)
                self.rect("m1", x_hi, ry - RAIL_W / 2, r5(x1 + rw) - 0.05, ry + RAIL_W / 2)
        merge_duplicate_proxies()
        box = self.top.dbbox()
        m3 = sum((hi - lo) for t in track for _, lo, hi in t.values())
        msg = (f"{box.width():.1f} x {box.height():.1f} um, "
               f"{sum(len(row['ports']) for row in rows)} pin connections, "
               f"{sum(len(t) for t in track)} trunks ({m3:.0f} um of Metal3), {len(riser)} risers")
        if not write:
            print(f"build_blocks: {self.name}: {msg}")
            return self.top
        out = os.path.join(HERE, self.name + ".gds")
        layout.write(out)
        print(f"build_blocks: wrote {out}: {msg}")


# ------------------------------------------------------------------ blocks --

def inv(a, y, vdd="vdd", vss="vss"):
    return ("sg13cmos5l_inv_1", {"A": a, "Y": y, "VDD": vdd, "VSS": vss})


def invlvw(a, y):
    return leaf("invlvw", [("vdd", 0.50, 2.03), ("vss", 1.115, 0.43), (a, 2.00, 1.23), (y, 2.48, 1.88)],
                well="vdd")


def dff_c2mos():
    b = Block("dff_c2mos", ["d", "clk", "q", "qb", "vdd", "vss"], ["vdd", "vss"], children=["invlvw"])
    # each latch's two transmission gates meet on its storage node
    b.add(tgate_pairs([((0.6, 1.2, "d", "net1", "clkb", "clki"), (0.3, 0.6, "net1", "net4", "clki", "clkb")),
                       ((0.6, 1.2, "net2", "net3", "clki", "clkb"), (0.3, 0.6, "net3", "net5", "clkb", "clki"))],
                      "vdd"), "MT1 MT2 MT3 MT4")
    b.add(invlvw("net2", "net4"), "XI2")
    b.add(stdcells(LV_LIB, [inv("clk", "clkb"), inv("clkb", "clki"), inv("net1", "net2"), inv("net3", "net6"),
                            inv("net6", "qb"), inv("qb", "q")]), "XI0 XI9 XI1 XI3 XI5 XI6")
    b.add(invlvw("net6", "net5"), "XI4")
    b.route()


def level_shifter_up():
    b = Block("level_shifter_up", ["in", "q_h", "qb_h", "vddl", "vddh", "vss"], ["vddl", "vddh", "vss"])
    b.add(stdcells(LV_LIB, [inv("in", "net3", "vddl")]), "XI")
    b.add(lv_chain("sg13_lv_nmos", 1.0, 0.13, ["net1", "in", "vss", "net3", "net2"]), "MN1 MN2")
    b.add(hv_row("sg13_hv_nmos", [(1.5, 0.45, ["net1", "vddl", "qb_h"]),
                                  (1.5, 0.45, ["q_h", "vddl", "net2"])], "vss"), "MC1 MC2")
    b.add(hv_row("sg13_hv_pmos", [(0.5, 1.6, ["qb_h", "q_h", "vddh", "qb_h", "q_h"])], "vddh"), "MP1 MP2")
    b.route()


def divider_16():
    b = Block("divider_16", ["in", "out", "vdd", "vss"], ["vdd", "vss"], children=["dff_c2mos"])
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
    b = Block("delay_2ns", ["a", "y", "vdd", "vss"], ["vdd", "vss"])
    nets = ["a", "net1", "net2", "net3", "y"]
    # MOS capacitors: gate on the node, source/drain on vss, so neighbours share a strip.
    # The inverters go on both sides of them: their substrate ties are the capacitors' too.
    b.add(stdcells(LV_LIB, [inv(nets[i], nets[i + 1]) for i in (0, 1)]), "X1 X2")
    b.add(lv_chain("sg13_lv_nmos", 7.4, 6.0, ["vss", "net1", "vss", "net2", "vss", "net3", "vss"]), "MC1 MC2 MC3")
    b.add(stdcells(LV_LIB, [inv(nets[i], nets[i + 1]) for i in (2, 3)]), "X3 X4")
    b.add(lv_chain("sg13_lv_nmos", 3.2, 6.0, ["vss", "y", "vss"]), "MC4")
    b.route()


def muxlv():
    b = Block("muxlv", ["in0", "in1", "sel", "out", "vdd", "vss"], ["vdd", "vss"])
    b.add(stdcells(LV_LIB, [inv("sel", "net1")]), "XI")
    b.add(tgate_pairs([((1.0, 2.0, "in0", "out", "net1", "sel"), (1.0, 2.0, "out", "in1", "sel", "net1"))],
                      "vdd"), "MT0 MT1")
    b.route()


def muxhv():
    b = Block("muxhv", ["in0", "in1", "sel", "selb", "out", "vdd", "vss"], ["vdd", "vss"])
    b.add(hv_row("sg13_hv_nmos", [(1.5, 0.45, ["in0", "selb", "out", "sel", "in1"])], "vss"), "MT0N MT1N")
    b.add(hv_row("sg13_hv_pmos", [(3.0, 0.45, ["in0", "sel", "out", "selb", "in1"])], "vdd"), "MT0P MT1P")
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
        (lv_chain("sg13_lv_pmos", 6.0, 0.13, fingers(4, "a_pad", "net22", L), L), "MPA"),
        (lv_chain("sg13_lv_nmos", 6.0, 0.13, fingers(2, "a_pad", "net23", "vss")), "MNA"),
        # data level shifter, 3.3 V pre-driver, 3.3 V receive path: the small
        # HV devices share one ring per well
        (lv_chain("sg13_lv_nmos", 2.0, 0.13, ["net11", "net9", "vss", "a_nb", "net13"]), "MN1 MN2"),
        (hv_row("sg13_hv_nmos", [(3.0, 0.45, ["net11", L, "net10"]), (3.0, 0.45, ["net12", L, "net13"]),
                                 (0.5, 0.45, ["net12", "enb_h", "vss"]), (1.0, 0.45, ["vss", "net17", "net18"]),
                                 (0.8, 0.45, ["net20", "net19", "vss"])], "vss"), "MN3 MN4 MN5 MN7 MN9"),
        (hv_row("sg13_hv_pmos", [(0.8, 0.8, ["net10", "net12", H, "net10", "net12"]),
                                 (1.5, 0.45, [H, "net17", "net18"])], H), "MP1 MP2 MP6"),
        (stdcells(HV_LIB, [hv("inv_1", A="net12", Y="net14"), hv("inv_2", A="net14", Y="z_h"),
                           hv("nand2_2", A="z_h", B="en_b_h", Y="net15"),
                           hv("nor2_2", A="z_h", B="enb_b_h", Y="net16")]), "XH1 XH2 XD1 XD2"),
        (rppd(1.0, 0.5, "b_pad", "net17"), "RSER"),
        (child("muxhv", {"in0": "net18", "in1": "z_h", "sel": "tm_h", "selb": "tmb_h", "out": "net19",
                         "vdd": H, "vss": "vss"}, well=H), "XM2"),
        (hv_row("sg13_hv_pmos", [(1.0, 0.45, ["net20", "net19", L])], L), "MP8"),
        # 3.3 V pad driver: one multi-finger device each
        (hv_row("sg13_hv_nmos", [(12.0, 0.45, fingers(4, "b_pad", "net16", "vss"))], "vss"), "MND"),
        (hv_row("sg13_hv_pmos", [(12.0, 0.45, fingers(8, "b_pad", "net15", H))], H), "MPD"),
    ]
    for inst, i, q, qb in (("XL2", "en", "en_h", "enb_h"), ("XL3", "tm", "tm_h", "tmb_h"),
                           ("XL1", "en_up", "en_b_h", "enb_b_h")):
        items.append((child("level_shifter_up",
                            {"in": i, "q_h": q, "qb_h": qb, "vddl": L, "vddh": H, "vss": "vss"}), inst))
    # Everything on a pad goes in the top row, next to the pins and in this
    # order: the 1.2 V receiver and driver, then the 3.3 V pre-driver, driver,
    # the 200 ohm series resistor and the 3.3 V receiver it protects. The pad
    # nets then stay in one channel and get wide trunks. The rest is packed
    # below at the row width that gives the smallest block.
    top_row = ["XRX", "MNA", "MPA", "XH1 XH2 XD1 XD2", "MPD", "MND", "RSER", "MN3 MN4 MN5 MN7 MN9",
               "MP1 MP2 MP6", "XM2", "MP8"]
    rest = [it for it in items if it[1] not in top_row]
    by_label = {it[1]: it[0] for it in items}

    def build(width):
        b = Block("bidir_channel", pins, [L, H, "vss"], wide=["a_pad", "b_pad"], ring="vss")
        b.pack(rest, width)
        b.end_row()
        for label in top_row:
            b.add(by_label[label], label)
        return b

    best = None
    for width in range(40, 131, 2):
        w, h = build(width).route(dry=True)
        if best is None or w * h < best[0]:
            best = (w * h, width)
    print(f"build_blocks: row width {best[1]} um gives the smallest area")
    build(best[1]).route()


# ---------------------------------------------------------------- slot top --

TOP = "slot_1"
WRAPPER = os.path.join(HERE, "floorplan", "slot1_wrapper.gds")
# Chipalooza slot 1 (github.com/RTimothyEdwards/sg13cmos5l_ocd_chipalooza,
# gds/slot1_wrapper.gds). The netlist is xschem/schematics/slot_1.sch.
VL, VH, VS = "vdd_1v2", "vdd_3v3", "vss_1v2"
# channel: (a_pad, b_pad); channels 1-3 share a 3.3 V bus, channel 0 is on the pads
PADS = {0: ("s1_an[0]", "s1_an[1]"), 1: ("a1", "b_bus"), 2: ("a2", "b_bus"), 3: ("a3", "b_bus")}


def slot_core():
    """The four channels and their interface logic, routed like any block.

    Bottom row: per channel a second divide-by-16 and, for channels 1-3, the
    gates that let dig_in drive their 1.2 V side. Top row: the channels,
    channel 0 at the east end next to the analog pads.
    """
    pins = ([f"dig_in[{i}]" for i in range(12)] + [f"dig_out[{i}]" for i in range(12)] +
            ["enable", "s1_an[0]", "s1_an[1]", VL, VH, VS])
    b = Block("slot_core", pins, [VL, VH, VS], wide=["s1_an[0]", "s1_an[1]", "b_bus"],
              children=["bidir_channel", "divider_16"])

    def lv(name, **pins):
        return ("sg13cmos5l_" + name, dict(pins, VDD=VL, VSS=VS))

    for k in (1, 2, 3, 0):
        b.add(child("divider_16", {"in": f"dig_out[{k}]", "out": f"dig_out[{4 + k}]", "vdd": VL, "vss": VS},
                    well=VL), f"XDV{k}")
        if k:
            a = PADS[k][0]
            b.add(stdcells(LV_LIB, [lv("or2_1", A=f"dig_in[{k}]", B=f"dig_in[{4 + k}]", X=f"teb{k}"),
                                    lv("ebufn_2", A=f"dig_in[{8 + k}]", TE_B=f"teb{k}", Z=a),
                                    lv("buf_1", A=a, X=f"dig_out[{7 + k}]")]), f"XTE{k} XDR{k} XRB{k}")
        else:
            b.add(stdcells(LV_LIB, [lv("buf_1", A="enable", X="dig_out[11]")]), "XEN")
    b.end_row()
    for k in (1, 2, 3, 0):
        a, p = PADS[k]
        b.add(child("bidir_channel", {"a_pad": a, "b_pad": p, "dir": f"dig_in[{k}]", "oe_n": "dig_in[8]",
                                      "en": "enable", "tm": f"dig_in[{4 + k}]", "ring_div": f"dig_out[{k}]",
                                      "vddl": VL, "vddh": VH, "vss": VS}), f"XCH{k}")
    return b.route(write=False)


def slot_top():
    """slot_core inside the slot 1 wrapper, wired to the wrapper's pins.

    The wrapper's shapes are kept as they are: Metal3 signal pins on the west
    edge, TopMetal1 supply pins on the west edge, the two analog pads on
    Metal3 at the east edge, and the PR boundary. Above the core:
      - signals: one Metal3 trunk each, west to a Metal2 column by the west
        edge, down to the pin's height and a Metal3 stub into the pin,
      - supplies: 4 um Metal3 straps joined to both ends of every core
        supply bus, a 4 um Metal4 riser by the west edge down to the
        supply's TopMetal1 pin, and a TopVia1 array into it,
      - the analog pads: 3 um Metal3 east and a 3 um Metal4 riser to the pad.
    """
    core = slot_core()
    wrap = pya.Layout()
    wrap.read(WRAPPER)
    src = wrap.top_cell()
    top = layout.create_cell(TOP)
    pins = {}                                   # pin name -> its pin-layer box
    texts = []
    for li in wrap.layer_indexes():
        info = wrap.get_info(li)
        dst = layout.layer(info.layer, info.datatype)
        for sh in src.shapes(li).each():
            top.shapes(dst).insert(sh)
            if sh.is_text():
                texts.append((sh.text.string, pya.DPoint(sh.text.x, sh.text.y) * wrap.dbu))
    for li in wrap.layer_indexes():
        info = wrap.get_info(li)
        if info.datatype != 2:
            continue
        for sh in src.shapes(li).each():
            b = sh.dbbox()
            for name, pt in texts:
                if b.contains(pt) and name not in pins:
                    pins[name] = b

    def rect(layer, x1, y1, x2, y2):
        top.shapes(LY[layer]).insert(pya.DBox(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)))

    def vias(layer, x1, y1, x2, y2, size=0.19, pitch=VIA_P, inset=0.05):
        x1, y1, x2, y2 = min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)
        nx = max(1, int((x2 - x1 - 2 * inset - size) / pitch + 1e-6) + 1)
        ny = max(1, int((y2 - y1 - 2 * inset - size) / pitch + 1e-6) + 1)
        for i in range(nx):
            for j in range(ny):
                cx = r5((x1 + x2) / 2 + (i - (nx - 1) / 2) * pitch)
                cy = r5((y1 + y2) / 2 + (j - (ny - 1) / 2) * pitch)
                rect(layer, cx - size / 2, cy - size / 2, cx + size / 2, cy + size / 2)

    cbox = core.dbbox()
    dx, dy = r5(60.0 - cbox.left), r5(6.0 - cbox.bottom)
    yt = r5(cbox.top + dy)                       # the core's pin edge
    ports = []                                  # (kind, net, x)
    for s in core.shapes(LY["text"]).each():
        if s.is_text() and ":" in s.text.string:
            kind, net = s.text.string.split(":", 1)
            ports.append((kind, net, r5(s.text.x * layout.dbu + dx)))
    inst = top.insert(pya.DCellInstArray(core.cell_index(), pya.DTrans(pya.DVector(dx, dy))))
    inst.flatten(1)
    layout.delete_cell(core.cell_index())
    for s in list(top.shapes(LY["text"]).each()):
        if s.is_text() and s.text.string.split(":")[0] in ("pin", "wpin", "bus"):
            top.shapes(LY["text"]).erase(s)

    # signals, nearest pin first so the columns don't need to cross
    sig = sorted([(net, x) for kind, net, x in ports if kind == "pin"], key=lambda p: -pins[p[0]].center().y)
    if len(sig) * PITCH + 4.0 > 30.0:
        fail("too many signal columns for the west margin")
    for k, (net, x) in enumerate(sig):
        ty, col = r5(yt + 1.0 + TRACK * k), r5(4.0 + PITCH * k)
        pb = pins[net]
        py = r5(pb.center().y)
        rect("m2", x - 0.10, yt - 0.2, x + 0.10, ty + 0.145)
        vias("v2", x - 0.095, ty - 0.095, x + 0.095, ty + 0.095, inset=0)
        rect("m3", col - 0.145, ty - 0.10, x + 0.145, ty + 0.10)
        rect("m2", col - 0.10, py - 0.145, col + 0.10, ty + 0.145)
        vias("v2", col - 0.095, ty - 0.095, col + 0.095, ty + 0.095, inset=0)
        vias("v2", col - 0.095, py - 0.095, col + 0.095, py + 0.095, inset=0)
        rect("m3", pb.left, pb.bottom, col + 0.145, pb.top)
    y = r5(yt + 1.0 + TRACK * len(sig) + 1.0)

    # supplies
    for k, net in enumerate((VL, VH, VS)):
        sy = r5(y + 2.0 + k * 5.0)              # strap centre, 4 um wide
        mx = r5(36.0 + k * 6.0)                 # west riser centre, 4 um wide
        xs = [x for kind, n, x in ports if kind == "bus" and n == net]
        rect("m3", mx - 2.0, sy - 2.0, max(xs) + BUS_W / 2, sy + 2.0)
        for x in xs:
            rect("m2", x - BUS_W / 2, yt - 0.3, x + BUS_W / 2, sy + 2.0)
            vias("v2", x - BUS_W / 2, sy - 2.0, x + BUS_W / 2, sy + 2.0)
        pb = pins[net]
        ty1, ty2 = r5(pb.center().y - 10.0), r5(pb.center().y + 10.0)
        rect("m4", mx - 2.0, min(ty1, sy - 2.0), mx + 2.0, max(ty2, sy + 2.0))
        vias("v3", mx - 2.0, sy - 2.0, mx + 2.0, sy + 2.0)
        # TopMetal1 from the pin across the riser, TopVia1 where they overlap
        rect("tm1", pb.left, ty1, mx + 2.0 + 0.42, ty2)
        vias("tv1", mx - 2.0, ty1, mx + 2.0, ty2, size=0.42, pitch=0.84, inset=0.45)
    y = r5(y + 15.0 + 1.0)

    # analog pads: the eastern one takes the lower track
    pads = sorted([(net, x) for kind, net, x in ports if kind == "wpin"], key=lambda p: -p[1])
    for k, (net, x) in enumerate(pads):
        py = r5(y + 1.5 + k * 4.5)              # 3 um Metal3 track
        mx = r5(518.0 + k * 5.0)                # 3 um Metal4 riser
        pb = pins[net]
        rect("m2", x - WIDE_W / 2, yt - 0.3, x + WIDE_W / 2, py + 1.5)
        vias("v2", x - WIDE_W / 2, py - 1.5, x + WIDE_W / 2, py + 1.5)
        rect("m3", x - WIDE_W / 2, py - 1.5, mx + 1.5, py + 1.5)
        cy = r5(pb.center().y)
        rect("m4", mx - 1.5, min(py, cy) - 1.5, mx + 1.5, max(py, cy) + 1.5)
        vias("v3", mx - 1.5, py - 1.5, mx + 1.5, py + 1.5)
        rect("m3", mx - 1.5, cy - 1.5, pb.right, cy + 1.5)
        vias("v3", mx - 1.5, cy - 1.5, mx + 1.5, cy + 1.5)

    merge_duplicate_proxies()
    out = os.path.join(HERE, "..", "gds", TOP + ".gds")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    layout.write(out)
    box = top.dbbox()
    print(f"build_blocks: wrote {os.path.normpath(out)}: {box.width():.1f} x {box.height():.1f} um, "
          f"core {cbox.width():.1f} x {cbox.height():.1f} um, top of routing at y = {y + 9.0:.1f} um")


BLOCKS = {f.__name__: f for f in (dff_c2mos, level_shifter_up, divider_16, delay_2ns, muxlv, muxhv,
                                  bidir_channel, slot_top)}
name = globals().get("block")
if name not in BLOCKS:
    fail("usage: klayout -zz -r build_blocks.py -rd block=<" + "|".join(BLOCKS) + ">")
BLOCKS[name]()
