# List supply connections made through a single contact or via.
#
# Every Cont, Via1-3 and TopVia1 on a supply net should have a second cut
# next to it, so one bad cut doesn't open a supply. For each cut layer this
# finds the overlap of the metal above (on a supply net) with what it lands
# on, and reports every overlap that holds only one cut, by the cell the cut
# is drawn in. Cuts inside PDK cells (standard cells, PCells) can't be
# changed here and are counted separately.
#
# Run in layout/ inside the container:
#   klayout -zz -r supply_cuts.py -rd cell=bidir_channel
# (the GDS is <cell>.gds here, or ../gds/<cell>.gds).

import collections
import os
import re
import pya

HERE = os.path.dirname(os.path.abspath(__file__))
SUPPLY = re.compile(r"^(vdd|vss|vddl|vddh|vdd_1v2|vdd_3v3|vss_1v2|vss_3v3|VDD|VSS)$")

cell = globals().get("cell")
path = os.path.join(HERE, cell + ".gds")
if not os.path.isfile(path):
    path = os.path.join(HERE, "..", "gds", cell + ".gds")
ly = pya.Layout()
ly.read(path)
top = ly.cell(cell)

l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, []))
L = {}
for name, ld in dict(activ=(1, 0), poly=(5, 0), cont=(6, 0), m1=(8, 0), v1=(19, 0), m2=(10, 0),
                     v2=(29, 0), m3=(30, 0), v3=(49, 0), m4=(50, 0), tv1=(125, 0), tm1=(126, 0)).items():
    L[name] = l2n.make_layer(ly.layer(*ld), name)
T = {name: l2n.make_text_layer(ly.layer(*ld), name + "t")
     for name, ld in dict(m1=(8, 25), m2=(10, 25), m3=(30, 25), m4=(50, 25), tm1=(126, 25)).items()}
stack = ["m1", "v1", "m2", "v2", "m3", "v3", "m4", "tv1", "tm1"]
for a, b in zip(stack, stack[1:]):
    l2n.connect(L[a], L[b])
for name in stack:
    l2n.connect(L[name])
l2n.connect(L["cont"], L["m1"])
for name, t in T.items():
    l2n.connect(L[name], t)
l2n.extract_netlist()

circ = l2n.netlist().circuit_by_name(cell) or list(l2n.netlist().each_circuit_top_down())[0]
supply_nets = [n for n in circ.each_net() if any(SUPPLY.match(s) for s in n.expanded_name().split(","))]

# which cell each cut is drawn in
def owner_map(layer):
    m = {}
    it = top.begin_shapes_rec(ly.layer(*layer))
    while not it.at_end():
        b = it.shape().bbox().transformed(it.trans())
        name = it.cell().name
        lib = it.cell().library() or (it.cell().is_pcell_variant() and "pcell")
        m[(b.left, b.bottom)] = (name, bool(lib))
        it.next()
    return m

CUTS = [("cont", (6, 0), "m1", ["activ", "poly"]), ("v1", (19, 0), "m2", ["m1"]),
        ("v2", (29, 0), "m3", ["m2"]), ("v3", (49, 0), "m4", ["m3"]), ("tv1", (125, 0), "tm1", ["m4"])]
pdk = collections.Counter()
own = collections.Counter()
where = collections.defaultdict(list)
for cut, ld, upper, lowers in CUTS:
    owners = owner_map(ld)
    lower = pya.Region()
    for lo in lowers:
        lower += L[lo]
    for net in supply_nets:
        up = l2n.shapes_of_net(net, L[upper], True)
        cuts = l2n.shapes_of_net(net, L[cut], True)
        if cuts.is_empty():
            continue
        if cut != "cont":
            lower = l2n.shapes_of_net(net, L[lowers[0]], True)
        islands = (up & lower).merged()
        for isl in islands.each():
            inside = cuts.interacting(pya.Region(isl))
            if inside.count() != 1:
                continue
            b = list(inside.each())[0].bbox()
            name, is_pdk = owners.get((b.left, b.bottom), ("?", False))
            key = (cut, name, net.expanded_name())
            if is_pdk:
                pdk[key] += 1
            else:
                own[key] += 1
                where[key].append(b.center().to_dtype(ly.dbu))

print(f"supply_cuts: {cell}: {sum(own.values())} single cuts in this repo's cells, "
      f"{sum(pdk.values())} in PDK cells")
for (cut, name, net), n in sorted(own.items()):
    pts = ", ".join(f"({p.x:.2f},{p.y:.2f})" for p in where[(cut, name, net)][:4])
    print(f"  single {cut:4s} x{n:<4d} in {name} on {net}: {pts}{' ...' if n > 4 else ''}")
for (cut, name, net), n in sorted(pdk.items()):
    print(f"  pdk    {cut:4s} x{n:<4d} in {name} on {net}")
