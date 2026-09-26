# Layout hierarchy

`./osic klayout -e`

This file shows which layout cells are placed inside which others. It
follows the schematic hierarchy, so the layout for each cell should contain
exactly the instances listed here. LVS will check that.

Lay out the leaf cells first, then work up the tree.

## Tree

`×N` is how many copies a cell places directly. Cells marked *(leaf)* hold
only transistors.

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
├── INVHV2T ×1
├── NANDHV ×1
├── NORHV ×1
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
| INVHV1S, INVHV2T, NANDHV, NORHV, MUXHV *(leaf)* | 1 each | bidir_channel |

## Suggested order

1. `INVLV`, then the other LV leaves (`INVLVW`, `NANDLV`, `NORLV`,
   `NAND3LV`, `SCHMLV`). Use one cell height and the same power rails for
   all of them so they butt together.
2. The HV leaves (`INVHV1S`, `INVHV2T`, `NANDHV`, `NORHV`, `MUXHV`).
3. The small composites: `AND2LV`, `AND3LV`, `OR2LV`, `MUXLV`.
4. The blocks: `dff_c2mos`, then `divider_16`, `delay_2ns` and
   `level_shifter_up`.
5. `bidir_channel`.

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
