# 4-channel 1.2 V ↔ 3.3 V level shifter for ihp sg13g2

Bidirectional voltage-domain level shifter IP for the IHP SG13G2 (SG13CMOS5L) open-source PDK. Chipalooza Challenge #2 entry.

## Background

Multi-voltage SoCs need a bridge wherever a 1.2 V digital core meets 3.3 V I/O. This block does that translation. It has four independent channels, each set to shift up (1.2 V to 3.3 V) or down (3.3 V to 1.2 V) with a direction pin, plus an output enable (tri-state) and a low-power shutdown. It is built from standard 1.2 V and 3.3 V MOS devices only.

## Simulation results

| | Forward 1.2 V to 3.3 V | Reverse 3.3 V to 1.2 V |
|---|---|---|
| t_pd (TT, 27 C, 5 pF) | 2.17 / 2.07 ns | 2.61 / 1.12 ns |
| worst case over 15 PVT corners | 3.86 ns | 4.22 ns |
| output levels | full rail, all corners | full rail, all corners |

![forward path](sim/results/01_forward_1v2_to_3v3.png)
![PVT corners](sim/results/09_pvt_corners.png)

Remaining issue: the reverse path has only 49 mV of DC input hysteresis
against 283 mV forward.
