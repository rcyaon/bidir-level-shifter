# Simulation — CPLZ-LS01 bidirectional channel

Every number and figure here comes from ngspice-47 running the **real IHP
SG13G2 (SG13CMOS5L) PSP103.6 device models**, not the placeholder LEVEL=1
models embedded in the xschem testbench sheet:

```
.lib $PDK/libs.tech/ngspice/models/cornerMOSlv.lib mos_<corner>
.lib $PDK/libs.tech/ngspice/models/cornerMOShv.lib mos_<corner>
```

`cplz_ls01_dut.spice` is the flattened channel netlist exported from
`../xschem/cplz_ls01/`. Regenerate it after editing the schematics with:

```
xschem -x -n -q -o . ../xschem/cplz_ls01/tb_channel.sch
```

## Running

```
bash runsim.sh tb1_fwd.sp        # one deck, measurements only
python3 summarize_pvt.py         # PVT table from the pvt_*.res files
python3 plot_results.py          # all figures -> results/*.png
python3 plot_results.py forward pvt   # just those two
```

`plot_results.py` runs each deck twice: once with `-r` for the waveform
rawfile, once without for the `.meas` results — ngspice refuses to evaluate
`.meas` in batch mode when a rawfile is requested.

Everything is meant to be run inside IIC-OSIC-TOOLS, where the PDK sits at
`/foss/pdks/ihp-sg13cmos5l`.

## Figures

| PNG | Deck | What it shows |
|---|---|---|
| `01_forward_1v2_to_3v3.png` | `tb1_fwd.sp` | Forward A to B transient, delay/rise/fall and supply current |
| `02_reverse_3v3_to_1v2.png` | `tb2_rev.sp` | Reverse B to A transient |
| `03_direction_flip_deadtime.png` | `tb5_dirflip.sp` | Break-before-make dead time on a direction reversal |
| `04_control_truth_table.png` | `tb3_truthtable.sp` | All 16 (dir, oe_n, en, tm) states vs internal driver enables |
| `05_shutdown_leakage.png` | `tb4_leak.sp` | Quiescent current with the channel disabled |
| `06_schmitt_hysteresis.png` | `tb7_schmitt.sp` | SCHMLV input receiver hysteresis loop |
| `07_dc_transfer_thresholds.png` | `tb13_thresh_*.sp` | Channel DC transfer, trip points, noise margins |
| `08_eye_and_rate_margin.png` | `tb12_fwd_*.sp` | PRBS5 eye at 400 Mb/s, level margin vs data rate |
| `09_pvt_corners.png` | `pvt_*.sp` | Propagation delay across 15 PVT corners, both directions |
| `10_testmode_ring_div16.png` | `tb6b_ringdiv.sp` | Test-mode ring oscillator and divide-by-16 monitor output |

## Headline results (TT, 27 C, nominal supplies, 5 pF load)

| | Forward A to B | Reverse B to A |
|---|---|---|
| t_pdLH | 2.17 ns | 2.61 ns |
| t_pdHL | 2.07 ns | 1.12 ns |
| t_rise / t_fall | 1.14 / 0.97 ns | 2.15 / 1.08 ns |
| V_OH | 3.300 V (full rail) | 1.200 V (full rail) |
| V_OL | 4.0 nV | 0.29 uV |
| I_DD average, switching | 1.167 mA (VDDH) | 0.321 mA (VDDL) |

- **PVT:** 15 corners (SS/SF/TT/FS/FF x {-40 C +10 %, 27 C nom,
  125 C -10 %}), both directions. Worst-case t_pd **4.22 ns**
  (reverse, SS, 125 C, -10 %). Level integrity passes at every corner —
  V_OH stays above 90 % and V_OL below 10 % of the receiving rail.
- **Dead time:** 6.73 ns forward-to-reverse, 6.80 ns reverse-to-forward.
  Both driver arms are off throughout, so the two domains never contend.
- **Shutdown:** worst case 5.7 nA on VDDL and 0.2 nA on VDDH, i.e.
  **7.51 nW per channel** with `en = 0, oe_n = 1`.
- **Thresholds:** forward channel V_IL 466 mV / V_IH 749 mV
  (283 mV hysteresis, NM_L 466 mV, NM_H 451 mV); reverse channel
  V_IL 1443 mV / V_IH 1493 mV (49 mV hysteresis).
- **Data rate:** the eye at b_pad is open through roughly 500 Mb/s into
  5 pF; beyond that the mid-eye levels close in (see figure 08).
- **Test mode:** ring oscillator 316.8 MHz, divider ratio exactly 16.00.

## Caveats

- The reverse path shows only 49 mV of DC hysteresis, versus 283 mV
  forward. That is thin for a 3.3 V input and is the number to watch if
  b_pad ever sees a slow or noisy edge.
- The PVT sweep covers +/-10 % supply at the temperature extremes only,
  not the full temperature-by-supply cross-product.
- Loading is a lumped 5 pF on the far pad. No package or board model.
- Layout parasitics are not included — these are schematic-level results.
