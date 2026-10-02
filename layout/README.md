# Layout hierarchy

`./osic klayout -e`

This file shows which layout cells are placed inside which others. It
follows the schematic hierarchy, so the layout for each cell should contain
exactly the instances listed here. LVS will check that.

Lay out the leaf cells first, then work up the tree.

## Tree

`×N` is how many copies a cell places directly. Cells marked *(leaf)* hold
only transistors. `sg13cmos5l_*` (1.2 V) and `sg13g2_hv_*` (3.3 V) cells come
from the PDK's standard-cell libraries and need no layout of their own.

```
bidir_channel                       one channel (+ 21 HV, 8 LV MOSFETs, 1 rppd)
├── level_shifter_up ×3             (+ 4 HV, 2 LV MOSFETs, inv_1)
├── divider_16 ×1                   (+ inv_1 ×2)
│   └── dff_c2mos ×4                (+ 8 LV MOSFETs, inv_1 ×6)
│       └── INVLVW ×2               (leaf)
├── delay_2ns ×2                    (+ 4 MOS capacitors, inv_1 ×4)
├── MUXLV ×1                        (+ 4 LV MOSFETs, inv_1)
├── MUXHV ×1                        (4 HV MOSFETs)
├── SCHMLV ×2                       (leaf)
├── sg13cmos5l_inv_1 ×5, or2_1 ×2, and3_1 ×2, and2_1 ×2, nand2_1 ×4, nor2_1 ×1
└── sg13g2_hv_inv_1, hv_inv_2, hv_nand2_2, hv_nor2_2
```

The logic gates used to be custom cells (`INVLV`, `NANDLV`, ...). They are now
the PDK's standard cells; `xschem/logic_gates/sg13cmos5l_*.sym/.sch` are local
symbols for them, with the transistor sizes of the PDK netlist. `INVLVW`,
`SCHMLV` and the two muxes have no library equivalent and stay custom.

## Building the blocks

`INVLVW` and `SCHMLV` are drawn by hand. Everything above them is placed and
routed by `build_blocks.py`: components in rows, a Metal2 stub from every pin
up into a channel above its row, one Metal3 trunk per net and channel, and a
Metal4 riser next to its pins for a net that spans rows. A block's pins end
as Metal2 stubs on its top edge. It is correct by construction and checked with DRC and LVS, but
not compact, and all wires are minimum width, including supplies and the pad
drivers' connections.

Build children first:

```sh
K=$PDK_ROOT/ihp-sg13cmos5l/libs.tech/klayout
export PDK=ihp-sg13cmos5l KLAYOUT_PATH=$HOME/.klayout:$K:$K/tech
for b in dff_c2mos divider_16 delay_2ns level_shifter_up muxlv muxhv bidir_channel; do
  klayout -zz -r build_blocks.py -rd block=$b
done
```

Run LVS on these in hierarchical mode (`--run_mode=deep`); in flat mode the
standard cells' own pin labels show up as extra top-level ports. DRC on
`bidir_channel` reports `Cnt.c.Digi` markers that come from the PDK's HV
standard cells themselves.

## Slot top level

`sg13cmos5l_bidir_level_shifter` is the tapeout macro: four channels inside
the Chipalooza `small` analog slot (500 um x 200 um). It starts from
`floorplan/chipalooza_template_small_analog.gds`, taken unchanged from
<https://github.com/RFICExplorer/sg13cmos5l_chipalooza_analog_project>, and
keeps its Metal3 signal pins (west edge), Metal2 analog pins (south edge),
Metal4 power straps and PR boundary as drawn.

| Template pin | Connected to |
|---|---|
| `VPWR`, `VAPWR`, `VGND` | `vddl` (1.2 V), `vddh` (3.3 V), `vss` of all channels |
| `analog_0`, `analog_1` | channel 0 `a_pad`, `b_pad` |
| `ui_in[3:0]` | `dir` of channels 0-3 |
| `ui_in[4]`, `ui_in[5]`, `ui_in[6]` | `oe_n`, `en`, `tm` (shared) |
| `uo_out[3:0]` | `ring_div` of channels 0-3 |

The pads of channels 1-3 are not brought out: a 3.3 V pad can't go to the
1.2 V digital pins, and the slot has three analog pins. Those channels are
reached through test mode only. The mapping is the `CHANNELS` and `SHARED`
tables in `build_blocks.py`; the schematic is
`xschem/schematics/sg13cmos5l_bidir_level_shifter.sch`.

```sh
klayout -zz -r build_blocks.py -rd block=slot_top
```

DRC reports 12 `metal4_drw_Offgrid` markers on the template's own second
strap group, which the bare template has too.

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
