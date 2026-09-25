# 4-channel 1.2 V ↔ 3.3 V level shifter for IHP SG13CMOS5L

Bidirectional voltage-domain level shifter IP for the IHP open-source PDK.[^ihp]
Chipalooza Challenge #2 entry.

Each of the four channels translates between a 1.2 V core and 3.3 V I/O, in
the direction set by a `dir` pin, with output enable (`oe_n`), a low-power
shutdown (`en`) and a built-in test mode (`tm`). It works like a TI
`SN74LVC8T245`,[^ti245] but as a hard macro inside a chip rather than a
packaged part, and it uses only the PDK's standard 1.2 V and 3.3 V devices.

![bidir_channel schematic](docs/img/bidir_channel.png)
<!-- screenshot: xschem/schematics/bidir_channel.sch -->

## How it works

The two directions need different circuits:

- **Going up is a logic problem.** 1.2 V is not high enough to switch off a
  PMOS on the 3.3 V rail, so a plain 3.3 V inverter would never fully turn off.
- **Going down is a reliability problem.** 3.3 V on the gate of a thin-oxide
  1.2 V transistor destroys it.

```
          1.2 V side                   |             3.3 V side
  a_pad -> Schmitt -> mux -> gate -----+-> up-shift latch -> buffers -> tri-state driver -> b_pad
                      ^tm   ^en_up     |                                                      |
  a_pad <- tri-state driver <- gate <- Schmitt <- down-shift inverter <- mux <- receiver <----+
                                ^en_a          |                         ^tm_h
```

Only one path drives at a time. The control logic picks which one.

**Control logic (1.2 V).** It turns `dir`, `oe_n`, `en` and `tm` into two
enables: `en_up` turns on the 3.3 V driver and `en_a` turns on the 1.2 V
driver. Each enable is ANDed with a copy of itself delayed by `delay_2ns`, so
drivers turn off immediately but turn on only after the delay. When `dir` flips,
the old driver is off before the new one comes on (break-before-make[^baker]),
so the two drivers never fight through the pads. Enables that the 3.3 V gates
need are carried up by small copies of `level_shifter_up`.

**Shifting up.** A cross-coupled HV PMOS latch[^rabaey][^cvsl] is flipped by a
1.2 V NMOS input pair. The PMOS pair is sized deliberately weak so the NMOS
pair always wins. HV NMOS cascodes with their gates tied to 1.2 V shield the
thin-oxide input devices from the 3.3 V swing above them, the same stacked-device
technique Wang et al. use for 1 V → 3.3 V.[^wang] `MN5` parks the latch in a
defined state when the block is off, so the shutdown leakage is tiny. The
output is a NAND/NOR-driven tri-state push-pull stage[^weste] sized for a 5 pF
pad.

**Shifting down.** No latch is needed, because 3.3 V already reads as a high to
1.2 V logic. The down-shift inverter is built from **HV devices powered from the
1.2 V rail**: the thick oxide tolerates 3.3 V on the gate, while the output only
swings 0–1.2 V. A Schmitt trigger[^schmitt] then squares up the slower edge, and
a 200 Ω series resistor isolates the pad from the receiver. (It is not an ESD
structure.)

**Test mode.** `tm = 1` enables both directions and reroutes two muxes, so the
signal goes up-shift → down-shift → back to the start. With an odd number of
inversions, the loop oscillates. `divider_16` (four C²MOS toggle
flip-flops[^c2mos]) divides that frequency by 16 onto `ring_div`, so the
translation speed can be measured on an ordinary pin.[^ring]

## Simulation

Screenshots from xschem's waveform viewer, running `tb_bidir_channel.sch`.

![forward: a_pad → b_pad](docs/img/sim_forward.png)
<!-- screenshot: a_pad and b_pad, dir = 0 (1.2 V → 3.3 V) -->

![reverse: b_pad → a_pad](docs/img/sim_reverse.png)
<!-- screenshot: b_pad and a_pad, dir = 1 (3.3 V → 1.2 V) -->

![direction flip and dead time](docs/img/sim_dirflip.png)
<!-- screenshot: dir, en_up / en_a (XCH.*) and supply current around the dir edge -->

![test-mode ring oscillator](docs/img/sim_testmode.png)
<!-- screenshot: tm = 1, z_h and ring_div -->

## Repository

```
xschemrc               sources the PDK's xschemrc, then adds the project library
xschem/logic_gates/    gate primitives (INV, NAND, NOR, MUX, Schmitt, ...)
xschem/schematics/     blocks (bidir_channel, level_shifter_up, dff_c2mos, divider_16, delay_2ns) + tb_bidir_channel
layout/                magic layout
docs/                  proposal and figures
```

To open the schematics:

```sh
export PDK_ROOT=/foss/pdks        # wherever open_pdks installed the PDK
xschem                            # from the repo root
```

The schematics use the `sg13cmos5l_pr/` device symbols, which only
`ihp-sg13cmos5l` ships. IIC-OSIC-TOOLS exports `PDK=ihp-sg13g2` by default, so
`xschemrc` switches to `ihp-sg13cmos5l` when it is installed and says so on
stderr.

[^ihp]: IHP Open Source PDK (SG13G2 / SG13CMOS5L), Apache 2.0. <https://github.com/IHP-GmbH/IHP-Open-PDK>

[^ti245]: Texas Instruments, *SN74LVC8T245 8-Bit Dual-Supply Bus Transceiver With Configurable Voltage Translation and 3-State Outputs*, datasheet. <https://www.ti.com/product/SN74LVC8T245>

[^baker]: R. J. Baker, *CMOS: Circuit Design, Layout, and Simulation*. Wiley-IEEE Press. Non-overlapping clock generation.

[^rabaey]: J. M. Rabaey, A. Chandrakasan, and B. Nikolić, *Digital Integrated Circuits: A Design Perspective*, 2nd ed. Prentice Hall, 2003.

[^cvsl]: L. G. Heller *et al.*, "Cascode voltage switch logic: A differential CMOS logic family," *ISSCC Dig. Tech. Papers*, 1984, pp. 16–17.

[^wang]: W.-T. Wang, M.-D. Ker, M.-C. Chiang, and C.-H. Chen, "Level shifters for high-speed 1-V to 3.3-V interfaces in a 0.13-µm Cu-interconnection/low-k CMOS technology," *Proc. VLSI-TSA*, 2001, pp. 307–310.

[^weste]: N. H. E. Weste and D. M. Harris, *CMOS VLSI Design*, 4th ed. Addison-Wesley, 2010.

[^schmitt]: I. M. Filanovsky and H. Baltes, "CMOS Schmitt trigger design," *IEEE Trans. Circuits Syst. I*, vol. 41, no. 1, pp. 46–49, 1994.

[^c2mos]: Y. Suzuki, K. Odagawa, and T. Abe, "Clocked CMOS calculator circuitry," *IEEE J. Solid-State Circuits*, vol. 8, no. 6, pp. 462–469, 1973.

[^ring]: M. Bhushan *et al.*, "Ring oscillators for CMOS process tuning and variability control," *IEEE Trans. Semicond. Manuf.*, vol. 19, no. 1, pp. 10–18, 2006.
