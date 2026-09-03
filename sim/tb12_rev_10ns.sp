* TB12 -- rev PRBS5 integrity, UI=10 ns (100 Mb/s), mid-eye sampled at tpd+UI/2
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 {VL}
Voe  oe_n 0 0
Ven  en   0 {VL}
Vtm  tm   0 0
Vsrc b_pad 0 PWL(0 {0*VH} 9.75n {0*VH} 10n {0*VH} 19.75n {0*VH} 20n {1*VH} 29.75n {1*VH} 30n {0*VH} 39.75n {0*VH} 40n {0*VH} 49.75n {0*VH} 50n {0*VH} 59.75n {0*VH} 60n {0*VH} 69.75n {0*VH} 70n {1*VH} 79.75n {1*VH} 80n {0*VH} 89.75n {0*VH} 90n {0*VH} 99.75n {0*VH} 100n {1*VH} 109.75n {1*VH} 110n {0*VH} 119.75n {0*VH} 120n {1*VH} 129.75n {1*VH} 130n {1*VH} 139.75n {1*VH} 140n {0*VH} 149.75n {0*VH} 150n {0*VH} 159.75n {0*VH} 160n {1*VH} 169.75n {1*VH} 170n {1*VH} 179.75n {1*VH} 180n {1*VH} 189.75n {1*VH} 190n {1*VH} 199.75n {1*VH} 200n {1*VH} 209.75n {1*VH} 210n {0*VH} 219.75n {0*VH} 220n {0*VH} 229.75n {0*VH} 230n {0*VH} 239.75n {0*VH} 240n {1*VH} 249.75n {1*VH} 250n {1*VH} 259.75n {1*VH} 260n {0*VH} 269.75n {0*VH} 270n {1*VH} 279.75n {1*VH} 280n {1*VH} 289.75n {1*VH} 290n {1*VH} 299.75n {1*VH} 300n {0*VH} 309.75n {0*VH} 310n {1*VH} 319.75n {1*VH} 320n {0*VH} 329.75n {0*VH} 330n {1*VH} 339.75n {1*VH} 340n {0*VH})
CLD a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 362.6n
.meas tran b02 FIND v(a_pad) AT=27.6n
.meas tran b03 FIND v(a_pad) AT=37.6n
.meas tran b04 FIND v(a_pad) AT=47.6n
.meas tran b05 FIND v(a_pad) AT=57.6n
.meas tran b06 FIND v(a_pad) AT=67.6n
.meas tran b07 FIND v(a_pad) AT=77.6n
.meas tran b08 FIND v(a_pad) AT=87.6n
.meas tran b09 FIND v(a_pad) AT=97.6n
.meas tran b10 FIND v(a_pad) AT=107.6n
.meas tran b11 FIND v(a_pad) AT=117.6n
.meas tran b12 FIND v(a_pad) AT=127.6n
.meas tran b13 FIND v(a_pad) AT=137.6n
.meas tran b14 FIND v(a_pad) AT=147.6n
.meas tran b15 FIND v(a_pad) AT=157.6n
.meas tran b16 FIND v(a_pad) AT=167.6n
.meas tran b17 FIND v(a_pad) AT=177.6n
.meas tran b18 FIND v(a_pad) AT=187.6n
.meas tran b19 FIND v(a_pad) AT=197.6n
.meas tran b20 FIND v(a_pad) AT=207.6n
.meas tran b21 FIND v(a_pad) AT=217.6n
.meas tran b22 FIND v(a_pad) AT=227.6n
.meas tran b23 FIND v(a_pad) AT=237.6n
.meas tran b24 FIND v(a_pad) AT=247.6n
.meas tran b25 FIND v(a_pad) AT=257.6n
.meas tran b26 FIND v(a_pad) AT=267.6n
.meas tran b27 FIND v(a_pad) AT=277.6n
.meas tran b28 FIND v(a_pad) AT=287.6n
.meas tran b29 FIND v(a_pad) AT=297.6n
.meas tran b30 FIND v(a_pad) AT=307.6n
.meas tran b31 FIND v(a_pad) AT=317.6n
.meas tran b32 FIND v(a_pad) AT=327.6n
.meas tran b33 FIND v(a_pad) AT=337.6n
.meas tran b34 FIND v(a_pad) AT=347.6n
.end
