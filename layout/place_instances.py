# Create a layout cell with every instance its netlist asks for, unrouted.
#
# Reads drc/symbols/<CELL>.spice or drc/schematics/<CELL>.spice and writes
# <cell>.gds next to this script. The cell gets:
#   - one SG13_dev PCell per MOSFET (m=N gives N separate devices),
#   - LV MOSFETs: one minimum-size body tap per cell, not per device:
#     a ptap1 if the cell has LV NMOS, an ntap1 if it has LV PMOS,
#   - HV MOSFETs: the PCell's own guard ring instead of a tap (psub ring
#     for nmosHV, nwell ring for pmosHV), for the pads and the 3.3 V side,
#   - one instance per X line, taken from the child's <child>.gds.
# Only the cell's own devices are placed, not the ones inside its children,
# so the hierarchy matches layout/README.md. Build children first.
#
# Run inside the container, from layout/, with KLAYOUT_PATH set for
# ihp-sg13cmos5l (see README.md):
#   klayout -zz -r place_instances.py -rd cell=AND2LV
# An existing <cell>.gds is replaced.

import os
import re
import sys
import pya

HERE = os.path.dirname(os.path.abspath(__file__))
TECH = "sg13cmos5l"
TEXT_LAYER = (63, 0)       # TEXT.drawing: comments only, ignored by DRC/LVS
GAP = 1.0                  # um between placed instances
PCELLS = {
    "sg13_lv_nmos": "nmos",
    "sg13_lv_pmos": "pmos",
    "sg13_hv_nmos": "nmosHV",
    "sg13_hv_pmos": "pmosHV",
}
TAP_MIN = "0.78u"          # ptap1_minLW / ntap1_minLW in sg13cmos5l_tech.json
TAPS = {"n": "ptap1", "p": "ntap1"}
RINGS = {"nmosHV": "psub", "pmosHV": "nwell"}   # guardRingType per HV PCell


def fail(msg):
    # klayout -r swallows the message of sys.exit(msg); print it ourselves.
    print(f"place_instances: {msg}", file=sys.stderr)
    sys.exit(1)


def find_netlist(name):
    for sub in ("symbols", "schematics"):
        path = os.path.join(HERE, "drc", sub, name + ".spice")
        if os.path.isfile(path):
            return path
    fail(f"no netlist for {name} under drc/")


def read_subckts(path):
    """Return {NAME: (ports, [element lines])} for every .subckt in path."""
    text = open(path).read().replace("\n+", " ")
    subckts, current = {}, None
    for line in text.splitlines():
        words = line.split()
        if not words or line.startswith("*"):
            continue
        key = words[0].lower()
        if key == ".subckt":
            current = words[1]
            subckts[current.upper()] = (words[2:], [])
        elif key == ".ends":
            current = None
        elif current:
            subckts[current.upper()][1].append(words)
    return subckts


def sg13_dev():
    for lid in pya.Library.library_ids():
        lib = pya.Library.library_by_id(lid)
        if lib.name() == "SG13_dev" and TECH in lib.technologies():
            return lib
    fail("SG13_dev PCell library not loaded; point KLAYOUT_PATH at "
         "ihp-sg13cmos5l/libs.tech/klayout (see README.md)")


def is_empty(path):
    ly = pya.Layout()
    ly.read(path)
    return all(c.is_empty() for c in ly.each_cell())


def load_child(layout, name, warnings):
    """Return the cell index of child `name`, reading <name>.gds if needed."""
    cell = layout.cell(name)
    if cell:
        return cell.cell_index()
    path = os.path.join(HERE, name + ".gds")
    if os.path.isfile(path) and not is_empty(path):
        opt = pya.LoadLayoutOptions()
        # Children share grandchildren (e.g. invlv); keep the first copy.
        opt.cell_conflict_resolution = pya.LoadLayoutOptions.SkipNewCell
        layout.read(path, opt)
        return layout.cell(name).cell_index()
    # No layout yet: an empty, labelled stand-in keeps the floorplan honest.
    warnings.append(f"{name}.gds missing or empty: placed an empty stand-in; "
                    f"lay out {name} and rerun")
    cell = layout.create_cell(name)
    text = layout.layer(*TEXT_LAYER)
    cell.shapes(text).insert(pya.DBox(0, 0, 2, 2))
    cell.shapes(text).insert(pya.DText(name, 0.1, 0.1))
    return cell.cell_index()


def main():
    name = globals().get("cell")
    if not name:
        fail("usage: klayout -zz -r place_instances.py -rd cell=<CELL>")
    subckts = read_subckts(find_netlist(name))
    if name.upper() not in subckts:
        fail(f".subckt {name} not in its netlist")
    _, elements = subckts[name.upper()]

    out = os.path.join(HERE, name.lower() + ".gds")

    layout = pya.Layout()
    layout.dbu = 0.001
    layout.technology_name = TECH
    top = layout.create_cell(name.lower())
    text = layout.layer(*TEXT_LAYER)
    lib = sg13_dev()

    # Rows, bottom to top: child cells, NMOS, PMOS.
    rows = {"x": [], "n": [], "p": []}
    lv_rows = set()        # rows that need a body tap
    warnings = []
    for words in elements:
        inst = words[0]
        kind = inst[0].upper()
        if kind == "M":
            model = words[5]
            if model not in PCELLS:
                warnings.append(f"{inst}: no PCell for model {model}; skipped")
                continue
            params = dict(w.split("=", 1) for w in words[6:] if "=" in w)
            m = int(params.pop("m", "1"))
            pcell = {k: params[k] for k in ("w", "l", "ng") if k in params}
            pcell["model"] = model
            if PCELLS[model] in RINGS:
                pcell["guardRingType"] = RINGS[PCELLS[model]]
            var = layout.add_pcell_variant(lib, lib.layout().pcell_id(PCELLS[model]), pcell)
            row = "p" if "pmos" in model else "n"
            if PCELLS[model] not in RINGS:
                lv_rows.add(row)
            for i in range(m):
                rows[row].append((inst if m == 1 else f"{inst}.{i + 1}", var))
        elif kind == "X":
            rows["x"].append((inst, load_child(layout, words[-1].lower(), warnings)))
        else:
            warnings.append(f"{inst}: {' '.join(words)} has no layout device; "
                            f"skipped")

    counts = {r: len(v) for r, v in rows.items()}
    # Created only when needed: an unused PCell variant would be a stray
    # top cell in the GDS.
    for row in sorted(lv_rows):
        tap = layout.add_pcell_variant(lib, lib.layout().pcell_id(TAPS[row]),
                                       {"w": TAP_MIN, "l": TAP_MIN})
        rows[row].append((TAPS[row], tap))

    y = 0.0
    for row in ("x", "n", "p"):
        x, height = 0.0, 0.0
        for inst, ci in rows[row]:
            box = layout.cell(ci).dbbox()
            trans = pya.DCplxTrans(x - box.left, y - box.bottom)
            top.insert(pya.DCellInstArray(ci, trans))
            top.shapes(text).insert(pya.DText(inst, x, y + box.height() + 0.1))
            x += box.width() + GAP
            height = max(height, box.height())
        if rows[row]:
            y += height + 2 * GAP

    layout.write(out)
    print(f"place_instances: wrote {out}: {counts['p']} PMOS, {counts['n']} NMOS, "
          f"{counts['x']} subcells, taps: {' '.join(TAPS[r] for r in sorted(lv_rows)) or 'none'}")
    for w in warnings:
        print(f"place_instances: warning: {w}")


main()
