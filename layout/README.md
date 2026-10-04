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
slot_1                              the tapeout cell, in gds/ (see "Slot top level")
├── bidir_channel ×4
├── divider_16 ×4                   (ring_div / 16 again)
└── sg13cmos5l_or2_1, ebufn_2, buf_1 ×3, buf_1

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
as Metal2 stubs on its top edge. It is correct by construction and checked
with DRC and LVS (`check.sh`).

Supplies and pads don't use those minimum-width wires:

- **Power.** Above every row each supply gets a 1 µm Metal1 rail across the
  whole block. Every supply pin in the row reaches its rail on a short Metal2
  stub with two vias. The rails of one supply are joined by a 1.2 µm Metal2
  bus down *both* sides of the block, with a via array at every rail, and
  those buses are the block's supply pins at its top edge. A parent runs each
  child's buses up into its own rails, so every level is strapped the same
  way, from the slot down to the flip-flops.
- **Pads.** `a_pad` and `b_pad` (and the slot's pad nets) are "wide": a
  1 µm trunk (three tracks), three vias on every stub into it, and a 1 µm pin.
  All their devices sit in the channel's top row, so they never need a
  riser.
- **Gate contacts.** A gate pad gets as many contacts as fit across it, not
  one. Neighbouring fingers on one net share a poly bar with a row of
  contacts along it: the pad drivers `MPD`/`MND`, `MPA`/`MNA`, and the
  6 µm-long MOS capacitors in `delay_2ns`.
- **Guard ring.** `bidir_channel` sits in a p-substrate guard ring (the
  process has no deep n-well), tied to `vss` by every `vss` rail on both
  sides.
- **Top row of the channel**, west to east: 1.2 V receiver `XRX`, 1.2 V
  driver `MNA`/`MPA`, 3.3 V pre-driver, 3.3 V driver `MPD`/`MND`, the 200 Ω
  series resistor `RSER` and the 3.3 V receiver it protects. Everything else
  is packed below at the row width that gives the smallest block.

The script keeps transistors close together:

- Devices with a common net and the same size are drawn as fingers of one
  PCell and share that diffusion strip (`lv_chain`, `hv_row`): the latch
  pairs in the level shifters, both halves of `MUXHV` and `MUXLV`, the MOS
  capacitors in `delay_2ns`.
- HV devices of one type and bulk sit in one guard ring (`hv_row`), 0.27 µm
  from the thick oxide instead of the PCell's 1 µm.
- Transmission gates sit in pairs in one well with one tap (`tgate_pairs`).
- Standard cells abut in runs and share their rails.

The routing channels above each row are not optimised.

Build children first:

```sh
K=$PDK_ROOT/ihp-sg13cmos5l/libs.tech/klayout
export PDK=ihp-sg13cmos5l KLAYOUT_PATH=$HOME/.klayout:$K:$K/tech
for b in dff_c2mos divider_16 delay_2ns level_shifter_up muxlv muxhv bidir_channel; do
  klayout -zz -r build_blocks.py -rd block=$b
done
```

Then `klayout -zz -r build_blocks.py -rd block=slot_top` for the slot.

## Checking

`check.sh` runs KLayout DRC, KLayout LVS and magic DRC on cells and prints
one line each:

```sh
sh check.sh dff_c2mos level_shifter_up delay_2ns muxlv muxhv divider_16 bidir_channel slot_1
```

LVS runs in hierarchical mode with tap extraction off (the schematics have no
taps); in flat mode the standard cells' own pin labels show up as extra
top-level ports. Everything is clean and matches, except that KLayout DRC
reports 112 `Cnt.c.Digi` markers on `bidir_channel` and `slot_1`; they come
from the PDK's HV standard cells themselves.

The stub pitch is 0.42 µm, not the 0.41 µm the rules allow: at 0.41 two
neighbouring Via1s are exactly 0.22 µm apart, and magic merges them into one
contact and then reports Metal1 missing between them.

`pex.sh bidir_channel` extracts the channel with its parasitic capacitances
(magic, flattened, no resistance) for the post-layout runs in
`verification/`.

## Slot top level

`slot_1` is the tapeout cell: `gds/slot_1.gds`, top cell `slot_1`, which is
the name and place the harness's `scripts/get_project_gds.sh` looks for. It
starts from `floorplan/slot1_wrapper.gds`, taken unchanged from
<https://github.com/RTimothyEdwards/sg13cmos5l_ocd_chipalooza/tree/main/gds>
(537.15 × 273 µm), and keeps its pins and PR boundary as drawn. The
schematic is `xschem/schematics/slot_1.sch`.

The core (four channels and the interface gates, 435 × 143 µm) is routed
like any block and sits at the south-west. Above it: one Metal3 trunk per
signal to a Metal2 column by the west edge and a Metal3 stub into its pin;
4 µm Metal3 straps joined to both ends of every core supply bus, each with a
4 µm Metal4 riser and a TopVia1 array into its TopMetal1 pin; and 3 µm
Metal3/Metal4 to the two analog pads on the east edge.

The harness gives the slot 24 `dig_in` bits (latched from SPI, or routed in
real time from a GPIO), 12 `dig_out` bits (read back over SPI or routed to a
GPIO), `enable`, `clk`, `reset` and two analog pads. Four channels need far
more than two pads, so:

- **Channel 0** is the one on pads: `a_pad` on `s1_an[0]`, `b_pad` on
  `s1_an[1]`.
- **Channels 1-3** share one 3.3 V bus (`b_bus`, inside the slot). Their
  1.2 V sides are digital: `dig_in` drives `a` through a tri-state buffer
  that is off whenever the channel drives `a` itself (`dir = 1` or
  `tm = 1`), and `a` is buffered back out on `dig_out`. With channel 1 at
  `dir = 0` and channel 2 at `dir = 1`, a bit goes `dig_in[9]` → channel 1
  up to 3.3 V → `b_bus` → channel 2 down to 1.2 V → `dig_out[9]`; swap the
  `dir` bits for the other way.
- **Test mode** is per channel, so one channel can ring while the others on
  `b_bus` listen. Each `ring_div` (ring / 16) goes out directly and once more
  through a second `divider_16` (ring / 256), so the ring can be measured on
  a slow output.

| Wrapper pin | Connected to |
|---|---|
| `vdd_1v2`, `vdd_3v3`, `vss_1v2` | `vddl`, `vddh`, `vss` of everything |
| `vss_3v3` | not connected (see below) |
| `enable` | `en` of all channels; also echoed on `dig_out[11]` |
| `s1_an[0]`, `s1_an[1]` | channel 0 `a_pad`, `b_pad` |
| `dig_in[3:0]` | `dir` of channels 0-3 |
| `dig_in[7:4]` | `tm` of channels 0-3 |
| `dig_in[8]` | `oe_n` (shared) |
| `dig_in[11:9]` | data into `a` of channels 1-3 |
| `dig_out[3:0]` | `ring_div` (ring / 16) of channels 0-3 |
| `dig_out[7:4]` | ring / 256 of channels 0-3 |
| `dig_out[10:8]` | `a` of channels 1-3 |
| `dig_out[11]` | `enable`, as a sign of life |

`dig_in[23:12]`, `clk`, `reset`, `s1_an_0_esd`, the bias pins and the analog
buses are not used. The channel has one ground, tied to `vss_1v2`.
The harness's RTL ties `vss3v3` to `vss1v2`, but its README says the two
ground domains are meant to be separate, so the slot doesn't short them;
this needs confirming with the harness.

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
