* TB12 -- fwd PRBS5, UI=1.25 ns (800 Mb/s), DUT=cplz_ls01_dut.spice
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 0
Voe oe_n 0 0
Ven en 0 {VL}
Vtm tm 0 0
Vsrc a_pad 0 PWL(0 {0*VL} 1.1n {0*VL} 1.25n {0*VL} 2.35n {0*VL} 2.5n {1*VL} 3.6n {1*VL} 3.75n {0*VL} 4.85n {0*VL} 5n {0*VL} 6.1n {0*VL} 6.25n {0*VL} 7.35n {0*VL} 7.5n {0*VL} 8.6n {0*VL} 8.75n {1*VL} 9.85n {1*VL} 10n {0*VL} 11.1n {0*VL} 11.25n {0*VL} 12.35n {0*VL} 12.5n {1*VL} 13.6n {1*VL} 13.75n {0*VL} 14.85n {0*VL} 15n {1*VL} 16.1n {1*VL} 16.25n {1*VL} 17.35n {1*VL} 17.5n {0*VL} 18.6n {0*VL} 18.75n {0*VL} 19.85n {0*VL} 20n {1*VL} 21.1n {1*VL} 21.25n {1*VL} 22.35n {1*VL} 22.5n {1*VL} 23.6n {1*VL} 23.75n {1*VL} 24.85n {1*VL} 25n {1*VL} 26.1n {1*VL} 26.25n {0*VL} 27.35n {0*VL} 27.5n {0*VL} 28.6n {0*VL} 28.75n {0*VL} 29.85n {0*VL} 30n {1*VL} 31.1n {1*VL} 31.25n {1*VL} 32.35n {1*VL} 32.5n {0*VL} 33.6n {0*VL} 33.75n {1*VL} 34.85n {1*VL} 35n {1*VL} 36.1n {1*VL} 36.25n {1*VL} 37.35n {1*VL} 37.5n {0*VL} 38.6n {0*VL} 38.75n {1*VL} 39.85n {1*VL} 40n {0*VL} 41.1n {0*VL} 41.25n {1*VL} 42.35n {1*VL} 42.5n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 47.2n
.meas tran b02 FIND v(b_pad) AT=5.325n
.meas tran b03 FIND v(b_pad) AT=6.575n
.meas tran b04 FIND v(b_pad) AT=7.825n
.meas tran b05 FIND v(b_pad) AT=9.075n
.meas tran b06 FIND v(b_pad) AT=10.325n
.meas tran b07 FIND v(b_pad) AT=11.575n
.meas tran b08 FIND v(b_pad) AT=12.825n
.meas tran b09 FIND v(b_pad) AT=14.075n
.meas tran b10 FIND v(b_pad) AT=15.325n
.meas tran b11 FIND v(b_pad) AT=16.575n
.meas tran b12 FIND v(b_pad) AT=17.825n
.meas tran b13 FIND v(b_pad) AT=19.075n
.meas tran b14 FIND v(b_pad) AT=20.325n
.meas tran b15 FIND v(b_pad) AT=21.575n
.meas tran b16 FIND v(b_pad) AT=22.825n
.meas tran b17 FIND v(b_pad) AT=24.075n
.meas tran b18 FIND v(b_pad) AT=25.325n
.meas tran b19 FIND v(b_pad) AT=26.575n
.meas tran b20 FIND v(b_pad) AT=27.825n
.meas tran b21 FIND v(b_pad) AT=29.075n
.meas tran b22 FIND v(b_pad) AT=30.325n
.meas tran b23 FIND v(b_pad) AT=31.575n
.meas tran b24 FIND v(b_pad) AT=32.825n
.meas tran b25 FIND v(b_pad) AT=34.075n
.meas tran b26 FIND v(b_pad) AT=35.325n
.meas tran b27 FIND v(b_pad) AT=36.575n
.meas tran b28 FIND v(b_pad) AT=37.825n
.meas tran b29 FIND v(b_pad) AT=39.075n
.meas tran b30 FIND v(b_pad) AT=40.325n
.meas tran b31 FIND v(b_pad) AT=41.575n
.meas tran b32 FIND v(b_pad) AT=42.825n
.meas tran b33 FIND v(b_pad) AT=44.075n
.meas tran b34 FIND v(b_pad) AT=45.325n
.end
