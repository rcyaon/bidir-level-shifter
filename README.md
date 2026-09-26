# 4-channel 1.2 V ↔ 3.3 V level shifter for IHP SG13CMOS5L

A level shifter for the IHP open-source PDK, made for Chipalooza Challenge #2.

Each channel moves a signal between 1.2 V and 3.3 V. The `dir` pin picks the
direction. There is also an output enable (`oe_n`), a shutdown pin (`en`) and
a test mode (`tm`). It works like a TI `SN74LVC8T245`, but as a block inside a
chip. It only uses the PDK's normal 1.2 V and 3.3 V transistors.

## How it works

- **Going up (1.2 → 3.3 V):** 1.2 V can't turn off a 3.3 V PMOS. So a
  cross-coupled latch does the job. Thick-oxide cascodes keep 3.3 V off the
  thin 1.2 V transistors.
- **Going down (3.3 → 1.2 V):** 3.3 V would break a 1.2 V gate. So the first
  inverter uses thick-oxide transistors run from 1.2 V. A Schmitt trigger
  cleans up the edge.
- **Direction switch:** each driver turns off right away but turns on only
  after a delay (`delay_2ns`). So the two sides never drive at the same time.
- **Test mode:** `tm = 1` loops the channel back on itself so it rings.
  `divider_16` slows that down by 16 so you can measure it on a normal pin.

## Verification

Screenshots, what each one proves, and area estimates are in
[verification/](verification/README.md).

## Files

```
xschem/logic_gates/   basic gates (INV, NAND, NOR, MUX, Schmitt, ...)
xschem/schematics/    blocks: bidir_channel, level_shifter_up, dff_c2mos, divider_16, delay_2ns
verification/         testbenches, screenshots, area estimate
layout/               magic layout
docs/                 proposal
```

To open the schematics:

```sh
export PDK_ROOT=/foss/pdks   # where the PDK is installed
xschem                       # from the repo root
```

The schematics need `ihp-sg13cmos5l`. `xschemrc` picks it for you if it is
installed.

## References

- IHP Open PDK: <https://github.com/IHP-GmbH/IHP-Open-PDK>
- TI SN74LVC8T245 datasheet: <https://www.ti.com/product/SN74LVC8T245>
- W.-T. Wang *et al.*, "Level shifters for high-speed 1-V to 3.3-V interfaces
  in a 0.13-µm Cu-interconnection/low-k CMOS technology," *VLSI-TSA*, 2001.
