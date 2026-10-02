#!/usr/bin/env python3
# Turn layout/*.gds into the JSON files the viewer in this folder draws.
#
# Each top cell is flattened and written as data/<cell>.json: polygons per
# layer in nanometres (four numbers for a box, x/y pairs otherwise) and the
# cell's own text labels. data/index.json lists the cells and the layers.
#
# Needs gdstk (pip install gdstk). Run from anywhere:
#   python3 docs/viewer/make_data.py

import glob
import json
import os

import gdstk

HERE = os.path.dirname(os.path.abspath(__file__))
LAYOUT = os.path.join(HERE, "..", "..", "layout")

# (layer, datatype): name, colour, fill opacity. Listed bottom to top, which
# is also the drawing order. Colours follow the PDK's KLayout layer file.
LAYERS = [
    ((31, 0), "NWell", "#268c6b", 0.25),
    ((40, 0), "Substrate tie", "#bbbbbb", 0.08),
    ((44, 0), "ThickGateOx", "#ffffcc", 0.07),
    ((1, 0), "Activ", "#00ff00", 0.35),
    ((14, 0), "pSD", "#ccb899", 0.15),
    ((28, 0), "SalBlock", "#9900e6", 0.30),
    ((5, 0), "GatPoly", "#bf4026", 0.70),
    ((6, 0), "Cont", "#00ffff", 0.80),
    ((8, 0), "Metal1", "#39bfff", 0.45),
    ((19, 0), "Via1", "#ccccff", 0.90),
    ((10, 0), "Metal2", "#ccccd9", 0.40),
    ((29, 0), "Via2", "#ff3736", 0.90),
    ((30, 0), "Metal3", "#d80000", 0.45),
    ((49, 0), "Via3", "#9ba940", 0.90),
    ((50, 0), "Metal4", "#93e837", 0.45),
    ((189, 4), "PR boundary", "#c070ff", 0.0),
]
# net labels and instance names; "pin:" markers are for build_blocks.py only
TEXT_LAYERS = {(8, 25): "net", (10, 25): "net", (30, 25): "net", (50, 25): "net", (63, 0): "inst"}


def main():
    known = {ld for ld, _, _, _ in LAYERS}
    os.makedirs(os.path.join(HERE, "data"), exist_ok=True)
    cells = []
    for path in sorted(glob.glob(os.path.join(LAYOUT, "*.gds"))):
        lib = gdstk.read_gds(path)
        name = os.path.splitext(os.path.basename(path))[0]
        top = next((c for c in lib.cells if c.name == name), None)
        if top is None:
            continue
        labels = [[t.text, round(t.origin[0] * 1000), round(t.origin[1] * 1000),
                   TEXT_LAYERS[(t.layer, t.texttype)]]
                  for t in top.labels
                  if (t.layer, t.texttype) in TEXT_LAYERS and not t.text.startswith("pin:")]
        flat = top.copy(name + "_flat").flatten()
        layers, count = {}, 0
        for poly in flat.polygons:
            ld = (poly.layer, poly.datatype)
            if ld not in known:
                continue
            (x1, y1), (x2, y2) = poly.bounding_box()
            pts = [(round(x * 1000), round(y * 1000)) for x, y in poly.points]
            if len(pts) == 4 and all(x in (round(x1 * 1000), round(x2 * 1000)) and
                                     y in (round(y1 * 1000), round(y2 * 1000)) for x, y in pts):
                shape = [round(x1 * 1000), round(y1 * 1000), round(x2 * 1000), round(y2 * 1000)]
            else:
                shape = [v for p in pts for v in p]
            layers.setdefault(f"{ld[0]}/{ld[1]}", []).append(shape)
            count += 1
        (x1, y1), (x2, y2) = top.bounding_box()
        bbox = [round(v * 1000) for v in (x1, y1, x2, y2)]
        with open(os.path.join(HERE, "data", name + ".json"), "w") as f:
            json.dump({"name": name, "bbox": bbox, "layers": layers, "labels": labels}, f,
                      separators=(",", ":"))
        cells.append({"name": name, "width": round(x2 - x1, 2), "height": round(y2 - y1, 2),
                      "shapes": count})
        print(f"{name}: {count} shapes, {x2 - x1:.1f} x {y2 - y1:.1f} um")
    cells.sort(key=lambda c: -c["shapes"])
    with open(os.path.join(HERE, "data", "index.json"), "w") as f:
        json.dump({"cells": cells,
                   "layers": [{"id": f"{ld[0]}/{ld[1]}", "name": n, "color": c, "alpha": a}
                              for ld, n, c, a in LAYERS]}, f, indent=1)


if __name__ == "__main__":
    main()
