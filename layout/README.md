# Layout hierarchy

`./osic klayout -e`

This file shows which layout cells are placed inside which others. It
follows the schematic hierarchy, so the layout for each cell should contain
exactly the instances listed here. LVS will check that.

Lay out the leaf cells first, then work up the tree.

## Tree

`×N` is how many copies a cell places directly. Cells marked *(leaf)* hold
only transistors. `sg13g2_hv_*` cells come from the PDK's
`sg13cmos5l_stdcell_hv` library and need no layout of their own.

```
bidir_channel                       one channel (+ 11 HV, 4 LV MOSFETs, 1 resistor)
├── level_shifter_up ×3             (+ 4 HV, 2 LV MOSFETs)
│   └── INVLV ×1
├── divider_16 ×1
│   ├── dff_c2mos ×4                (+ 8 LV MOSFETs)
│   │   ├── INVLV ×6
│   │   └── INVLVW ×2
│   └── INVLV ×2
├── delay_2ns ×2                    (+ 4 capacitors)
│   └── INVLV ×4
├── AND2LV ×2
│   ├── NANDLV ×1
│   └── INVLV ×1
├── AND3LV ×2
│   ├── NAND3LV ×1
│   └── INVLV ×1
├── OR2LV ×2
│   ├── NORLV ×1
│   └── INVLV ×1
├── MUXLV ×1                        (+ 4 LV MOSFETs)
│   └── INVLV ×1
├── INVLV ×5
├── NANDLV ×3
├── NORLV ×1
├── SCHMLV ×2
├── INVHV1S ×1
├── sg13g2_hv_inv_2 ×1            (PDK cell)
├── NANDHV ×1
├── sg13g2_hv_nor2_2 ×1           (PDK cell)
└── MUXHV ×1
```

## How often each cell appears in one channel

Counted through the whole tree. This shows where a good layout saves the
most time.

| Cell | Copies per channel | Placed inside |
|---|---:|---|
| INVLV *(leaf)* | 49 | almost everything |
| INVLVW *(leaf)* | 8 | dff_c2mos |
| NANDLV *(leaf)* | 5 | bidir_channel, AND2LV |
| dff_c2mos | 4 | divider_16 |
| NORLV *(leaf)* | 3 | bidir_channel, OR2LV |
| level_shifter_up | 3 | bidir_channel |
| NAND3LV *(leaf)* | 2 | AND3LV |
| AND2LV, AND3LV, OR2LV | 2 each | bidir_channel |
| delay_2ns | 2 | bidir_channel |
| SCHMLV *(leaf)* | 2 | bidir_channel |
| divider_16, MUXLV | 1 each | bidir_channel |
| INVHV1S, NANDHV, MUXHV *(leaf)* | 1 each | bidir_channel |

## Suggested order

1. `INVLV`, then the other LV leaves (`INVLVW`, `NANDLV`, `NORLV`,
   `NAND3LV`, `SCHMLV`). Use one cell height and the same power rails for
   all of them so they butt together.
2. The HV leaves (`INVHV1S`, `NANDHV`, `MUXHV`).
3. The small composites: `AND2LV`, `AND3LV`, `OR2LV`, `MUXLV`.
4. The blocks: `dff_c2mos`, then `divider_16`, `delay_2ns` and
   `level_shifter_up`.
5. `bidir_channel`.

## PDK standard cells in KLayout

The PDK registers only the 3.3 V cells (`sg13cmos5l_stdcell_hv`) as a
KLayout library. `klayout/pymacros/sg13cmos5l_stdcell.lym` adds the 1.2 V
cells as `sg13cmos5l_stdcell`. It lives in the container's `~/.klayout`,
not in the image, so copy it in again after recreating the container:

```sh
./osic bash -c 'mkdir -p ~/.klayout/pymacros && cp layout/klayout/pymacros/sg13cmos5l_stdcell.lym ~/.klayout/pymacros/'
```

Run this from the project folder.

## Placing a cell's instances from its netlist

`place_instances.py` reads a cell's netlist from `drc/` and writes
`<cell>.gds` with every instance that cell needs, placed in rows but not
wired: one SG13_dev PCell per MOSFET (`m=N` becomes N devices) and one
instance of each child cell, read from the child's `.gds`. Children named
`sg13g2_hv_*` or `sg13cmos5l_*` are PDK standard cells and are placed from
the KLayout libraries above instead. Body ties:

- LV cells get one minimum-size (0.78 µm × 0.78 µm) tap per cell, not per
  device: a `ptap1` if the cell has LV NMOS, an `ntap1` if it has LV PMOS.
  Move them under the rails so abutting cells share them.
- HV MOSFETs get the PCell's built-in guard ring instead (`psub` for
  `nmosHV`, `nwell` for `pmosHV`, 1 µm from the device). These are the pad
  drivers and the 3.3 V side, where latch-up and substrate noise matter.

Each instance gets its netlist name as a label on the TEXT layer. Run it in
`layout/` inside the container:

```sh
K=$PDK_ROOT/ihp-sg13cmos5l/libs.tech/klayout
export PDK=ihp-sg13cmos5l KLAYOUT_PATH=$HOME/.klayout:$K:$K/tech
klayout -zz -r place_instances.py -rd cell=AND2LV
```

The container defaults to `ihp-sg13g2`, and setting `PDK` alone doesn't
change `KLAYOUT_PATH`, so the SG13CMOS5L PCells wouldn't load.

If `<cell>.gds` already exists it is replaced. Build the children first. If
a child has no layout yet, the script puts in an empty labelled box and
prints a warning. Rerun once the child exists. Resistors with no PDK model (like `RSER` in `bidir_channel`)
are skipped with a warning.

## Netlists for LVS

`drc/` holds a SPICE netlist for every cell:

- `drc/schematics/` has the blocks from `xschem/schematics/`.
- `drc/symbols/` has the gates from `xschem/logic_gates/`.

To rebuild one, run this in the project folder inside the container. For
example, for `INVLV`:

```sh
xschem -n -s -q -x --tcl 'set top_subckt 1; set lvs_netlist 1' \
  -o layout/drc/symbols -N INVLV.spice xschem/logic_gates/INVLV.sch
```
