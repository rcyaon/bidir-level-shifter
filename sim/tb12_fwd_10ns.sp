* TB12 -- fwd PRBS5 integrity, UI=10 ns (100 Mb/s), mid-eye sampled at tpd+UI/2
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 0
Voe  oe_n 0 0
Ven  en   0 {VL}
Vtm  tm   0 0
Vsrc a_pad 0 PWL(0 {0*VL} 9.85n {0*VL} 10n {0*VL} 19.85n {0*VL} 20n {1*VL} 29.85n {1*VL} 30n {0*VL} 39.85n {0*VL} 40n {0*VL} 49.85n {0*VL} 50n {0*VL} 59.85n {0*VL} 60n {0*VL} 69.85n {0*VL} 70n {1*VL} 79.85n {1*VL} 80n {0*VL} 89.85n {0*VL} 90n {0*VL} 99.85n {0*VL} 100n {1*VL} 109.85n {1*VL} 110n {0*VL} 119.85n {0*VL} 120n {1*VL} 129.85n {1*VL} 130n {1*VL} 139.85n {1*VL} 140n {0*VL} 149.85n {0*VL} 150n {0*VL} 159.85n {0*VL} 160n {1*VL} 169.85n {1*VL} 170n {1*VL} 179.85n {1*VL} 180n {1*VL} 189.85n {1*VL} 190n {1*VL} 199.85n {1*VL} 200n {1*VL} 209.85n {1*VL} 210n {0*VL} 219.85n {0*VL} 220n {0*VL} 229.85n {0*VL} 230n {0*VL} 239.85n {0*VL} 240n {1*VL} 249.85n {1*VL} 250n {1*VL} 259.85n {1*VL} 260n {0*VL} 269.85n {0*VL} 270n {1*VL} 279.85n {1*VL} 280n {1*VL} 289.85n {1*VL} 290n {1*VL} 299.85n {1*VL} 300n {0*VL} 309.85n {0*VL} 310n {1*VL} 319.85n {1*VL} 320n {0*VL} 329.85n {0*VL} 330n {1*VL} 339.85n {1*VL} 340n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 362.2n
.meas tran b02 FIND v(b_pad) AT=27.2n
.meas tran b03 FIND v(b_pad) AT=37.2n
.meas tran b04 FIND v(b_pad) AT=47.2n
.meas tran b05 FIND v(b_pad) AT=57.2n
.meas tran b06 FIND v(b_pad) AT=67.2n
.meas tran b07 FIND v(b_pad) AT=77.2n
.meas tran b08 FIND v(b_pad) AT=87.2n
.meas tran b09 FIND v(b_pad) AT=97.2n
.meas tran b10 FIND v(b_pad) AT=107.2n
.meas tran b11 FIND v(b_pad) AT=117.2n
.meas tran b12 FIND v(b_pad) AT=127.2n
.meas tran b13 FIND v(b_pad) AT=137.2n
.meas tran b14 FIND v(b_pad) AT=147.2n
.meas tran b15 FIND v(b_pad) AT=157.2n
.meas tran b16 FIND v(b_pad) AT=167.2n
.meas tran b17 FIND v(b_pad) AT=177.2n
.meas tran b18 FIND v(b_pad) AT=187.2n
.meas tran b19 FIND v(b_pad) AT=197.2n
.meas tran b20 FIND v(b_pad) AT=207.2n
.meas tran b21 FIND v(b_pad) AT=217.2n
.meas tran b22 FIND v(b_pad) AT=227.2n
.meas tran b23 FIND v(b_pad) AT=237.2n
.meas tran b24 FIND v(b_pad) AT=247.2n
.meas tran b25 FIND v(b_pad) AT=257.2n
.meas tran b26 FIND v(b_pad) AT=267.2n
.meas tran b27 FIND v(b_pad) AT=277.2n
.meas tran b28 FIND v(b_pad) AT=287.2n
.meas tran b29 FIND v(b_pad) AT=297.2n
.meas tran b30 FIND v(b_pad) AT=307.2n
.meas tran b31 FIND v(b_pad) AT=317.2n
.meas tran b32 FIND v(b_pad) AT=327.2n
.meas tran b33 FIND v(b_pad) AT=337.2n
.meas tran b34 FIND v(b_pad) AT=347.2n
.end
