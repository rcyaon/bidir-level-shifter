# 4-channel 1.2 V ↔ 3.3 V level shifter for ihp sg13g2

Bidirectional voltage-domain level shifter IP for the IHP SG13G2 (SG13CMOS5L) open-source PDK. Chipalooza Challenge #2 entry.

## Background

Multi-voltage SoCs need a bridge wherever a 1.2 V digital core meets 3.3 V I/O. This block does that translation. It has four independent channels, each set on its own to shift up (1.2 V to 3.3 V) or down (3.3 V to 1.2 V) with a direction pin, plus an output enable (tri-state) and a low-power shutdown. It is built from standard 1.2 V and 3.3 V MOS devices only, with no bandgap, bias, or current-source resources.
