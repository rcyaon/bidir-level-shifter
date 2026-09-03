* TB12 -- fwd PRBS5, UI=1.5 ns (667 Mb/s), DUT=cplz_ls01_dut.spice
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
Vsrc a_pad 0 PWL(0 {0*VL} 1.35n {0*VL} 1.5n {0*VL} 2.85n {0*VL} 3n {1*VL} 4.35n {1*VL} 4.5n {0*VL} 5.85n {0*VL} 6n {0*VL} 7.35n {0*VL} 7.5n {0*VL} 8.85n {0*VL} 9n {0*VL} 10.35n {0*VL} 10.5n {1*VL} 11.85n {1*VL} 12n {0*VL} 13.35n {0*VL} 13.5n {0*VL} 14.85n {0*VL} 15n {1*VL} 16.35n {1*VL} 16.5n {0*VL} 17.85n {0*VL} 18n {1*VL} 19.35n {1*VL} 19.5n {1*VL} 20.85n {1*VL} 21n {0*VL} 22.35n {0*VL} 22.5n {0*VL} 23.85n {0*VL} 24n {1*VL} 25.35n {1*VL} 25.5n {1*VL} 26.85n {1*VL} 27n {1*VL} 28.35n {1*VL} 28.5n {1*VL} 29.85n {1*VL} 30n {1*VL} 31.35n {1*VL} 31.5n {0*VL} 32.85n {0*VL} 33n {0*VL} 34.35n {0*VL} 34.5n {0*VL} 35.85n {0*VL} 36n {1*VL} 37.35n {1*VL} 37.5n {1*VL} 38.85n {1*VL} 39n {0*VL} 40.35n {0*VL} 40.5n {1*VL} 41.85n {1*VL} 42n {1*VL} 43.35n {1*VL} 43.5n {1*VL} 44.85n {1*VL} 45n {0*VL} 46.35n {0*VL} 46.5n {1*VL} 47.85n {1*VL} 48n {0*VL} 49.35n {0*VL} 49.5n {1*VL} 50.85n {1*VL} 51n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 56.2n
.meas tran b02 FIND v(b_pad) AT=5.95n
.meas tran b03 FIND v(b_pad) AT=7.45n
.meas tran b04 FIND v(b_pad) AT=8.95n
.meas tran b05 FIND v(b_pad) AT=10.45n
.meas tran b06 FIND v(b_pad) AT=11.95n
.meas tran b07 FIND v(b_pad) AT=13.45n
.meas tran b08 FIND v(b_pad) AT=14.95n
.meas tran b09 FIND v(b_pad) AT=16.45n
.meas tran b10 FIND v(b_pad) AT=17.95n
.meas tran b11 FIND v(b_pad) AT=19.45n
.meas tran b12 FIND v(b_pad) AT=20.95n
.meas tran b13 FIND v(b_pad) AT=22.45n
.meas tran b14 FIND v(b_pad) AT=23.95n
.meas tran b15 FIND v(b_pad) AT=25.45n
.meas tran b16 FIND v(b_pad) AT=26.95n
.meas tran b17 FIND v(b_pad) AT=28.45n
.meas tran b18 FIND v(b_pad) AT=29.95n
.meas tran b19 FIND v(b_pad) AT=31.45n
.meas tran b20 FIND v(b_pad) AT=32.95n
.meas tran b21 FIND v(b_pad) AT=34.45n
.meas tran b22 FIND v(b_pad) AT=35.95n
.meas tran b23 FIND v(b_pad) AT=37.45n
.meas tran b24 FIND v(b_pad) AT=38.95n
.meas tran b25 FIND v(b_pad) AT=40.45n
.meas tran b26 FIND v(b_pad) AT=41.95n
.meas tran b27 FIND v(b_pad) AT=43.45n
.meas tran b28 FIND v(b_pad) AT=44.95n
.meas tran b29 FIND v(b_pad) AT=46.45n
.meas tran b30 FIND v(b_pad) AT=47.95n
.meas tran b31 FIND v(b_pad) AT=49.45n
.meas tran b32 FIND v(b_pad) AT=50.95n
.meas tran b33 FIND v(b_pad) AT=52.45n
.meas tran b34 FIND v(b_pad) AT=53.95n
.end
