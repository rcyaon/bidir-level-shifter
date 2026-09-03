* TB12 WHATIF 2x pull-up -- rev PRBS5, UI=2.5 ns (400 Mb/s), DUT=cplz_ls01_dut_whatifB.spice
.include cplz_ls01_dut_whatifB.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 {VL}
Voe oe_n 0 0
Ven en 0 {VL}
Vtm tm 0 0
Vsrc b_pad 0 PWL(0 {0*VH} 2.25n {0*VH} 2.5n {0*VH} 4.75n {0*VH} 5n {1*VH} 7.25n {1*VH} 7.5n {0*VH} 9.75n {0*VH} 10n {0*VH} 12.25n {0*VH} 12.5n {0*VH} 14.75n {0*VH} 15n {0*VH} 17.25n {0*VH} 17.5n {1*VH} 19.75n {1*VH} 20n {0*VH} 22.25n {0*VH} 22.5n {0*VH} 24.75n {0*VH} 25n {1*VH} 27.25n {1*VH} 27.5n {0*VH} 29.75n {0*VH} 30n {1*VH} 32.25n {1*VH} 32.5n {1*VH} 34.75n {1*VH} 35n {0*VH} 37.25n {0*VH} 37.5n {0*VH} 39.75n {0*VH} 40n {1*VH} 42.25n {1*VH} 42.5n {1*VH} 44.75n {1*VH} 45n {1*VH} 47.25n {1*VH} 47.5n {1*VH} 49.75n {1*VH} 50n {1*VH} 52.25n {1*VH} 52.5n {0*VH} 54.75n {0*VH} 55n {0*VH} 57.25n {0*VH} 57.5n {0*VH} 59.75n {0*VH} 60n {1*VH} 62.25n {1*VH} 62.5n {1*VH} 64.75n {1*VH} 65n {0*VH} 67.25n {0*VH} 67.5n {1*VH} 69.75n {1*VH} 70n {1*VH} 72.25n {1*VH} 72.5n {1*VH} 74.75n {1*VH} 75n {0*VH} 77.25n {0*VH} 77.5n {1*VH} 79.75n {1*VH} 80n {0*VH} 82.25n {0*VH} 82.5n {1*VH} 84.75n {1*VH} 85n {0*VH})
CLD a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 92.6n
.meas tran b02 FIND v(a_pad) AT=8.85n
.meas tran b03 FIND v(a_pad) AT=11.35n
.meas tran b04 FIND v(a_pad) AT=13.85n
.meas tran b05 FIND v(a_pad) AT=16.35n
.meas tran b06 FIND v(a_pad) AT=18.85n
.meas tran b07 FIND v(a_pad) AT=21.35n
.meas tran b08 FIND v(a_pad) AT=23.85n
.meas tran b09 FIND v(a_pad) AT=26.35n
.meas tran b10 FIND v(a_pad) AT=28.85n
.meas tran b11 FIND v(a_pad) AT=31.35n
.meas tran b12 FIND v(a_pad) AT=33.85n
.meas tran b13 FIND v(a_pad) AT=36.35n
.meas tran b14 FIND v(a_pad) AT=38.85n
.meas tran b15 FIND v(a_pad) AT=41.35n
.meas tran b16 FIND v(a_pad) AT=43.85n
.meas tran b17 FIND v(a_pad) AT=46.35n
.meas tran b18 FIND v(a_pad) AT=48.85n
.meas tran b19 FIND v(a_pad) AT=51.35n
.meas tran b20 FIND v(a_pad) AT=53.85n
.meas tran b21 FIND v(a_pad) AT=56.35n
.meas tran b22 FIND v(a_pad) AT=58.85n
.meas tran b23 FIND v(a_pad) AT=61.35n
.meas tran b24 FIND v(a_pad) AT=63.85n
.meas tran b25 FIND v(a_pad) AT=66.35n
.meas tran b26 FIND v(a_pad) AT=68.85n
.meas tran b27 FIND v(a_pad) AT=71.35n
.meas tran b28 FIND v(a_pad) AT=73.85n
.meas tran b29 FIND v(a_pad) AT=76.35n
.meas tran b30 FIND v(a_pad) AT=78.85n
.meas tran b31 FIND v(a_pad) AT=81.35n
.meas tran b32 FIND v(a_pad) AT=83.85n
.meas tran b33 FIND v(a_pad) AT=86.35n
.meas tran b34 FIND v(a_pad) AT=88.85n
.end
