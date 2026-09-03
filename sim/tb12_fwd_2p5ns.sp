* TB12 -- fwd PRBS5 integrity, UI=2.5 ns (400 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc a_pad 0 PWL(0 {0*VL} 2.35n {0*VL} 2.5n {0*VL} 4.85n {0*VL} 5n {1*VL} 7.35n {1*VL} 7.5n {0*VL} 9.85n {0*VL} 10n {0*VL} 12.35n {0*VL} 12.5n {0*VL} 14.85n {0*VL} 15n {0*VL} 17.35n {0*VL} 17.5n {1*VL} 19.85n {1*VL} 20n {0*VL} 22.35n {0*VL} 22.5n {0*VL} 24.85n {0*VL} 25n {1*VL} 27.35n {1*VL} 27.5n {0*VL} 29.85n {0*VL} 30n {1*VL} 32.35n {1*VL} 32.5n {1*VL} 34.85n {1*VL} 35n {0*VL} 37.35n {0*VL} 37.5n {0*VL} 39.85n {0*VL} 40n {1*VL} 42.35n {1*VL} 42.5n {1*VL} 44.85n {1*VL} 45n {1*VL} 47.35n {1*VL} 47.5n {1*VL} 49.85n {1*VL} 50n {1*VL} 52.35n {1*VL} 52.5n {0*VL} 54.85n {0*VL} 55n {0*VL} 57.35n {0*VL} 57.5n {0*VL} 59.85n {0*VL} 60n {1*VL} 62.35n {1*VL} 62.5n {1*VL} 64.85n {1*VL} 65n {0*VL} 67.35n {0*VL} 67.5n {1*VL} 69.85n {1*VL} 70n {1*VL} 72.35n {1*VL} 72.5n {1*VL} 74.85n {1*VL} 75n {0*VL} 77.35n {0*VL} 77.5n {1*VL} 79.85n {1*VL} 80n {0*VL} 82.35n {0*VL} 82.5n {1*VL} 84.85n {1*VL} 85n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 92.2n
.meas tran b02 FIND v(b_pad) AT=8.45n
.meas tran b03 FIND v(b_pad) AT=10.95n
.meas tran b04 FIND v(b_pad) AT=13.45n
.meas tran b05 FIND v(b_pad) AT=15.95n
.meas tran b06 FIND v(b_pad) AT=18.45n
.meas tran b07 FIND v(b_pad) AT=20.95n
.meas tran b08 FIND v(b_pad) AT=23.45n
.meas tran b09 FIND v(b_pad) AT=25.95n
.meas tran b10 FIND v(b_pad) AT=28.45n
.meas tran b11 FIND v(b_pad) AT=30.95n
.meas tran b12 FIND v(b_pad) AT=33.45n
.meas tran b13 FIND v(b_pad) AT=35.95n
.meas tran b14 FIND v(b_pad) AT=38.45n
.meas tran b15 FIND v(b_pad) AT=40.95n
.meas tran b16 FIND v(b_pad) AT=43.45n
.meas tran b17 FIND v(b_pad) AT=45.95n
.meas tran b18 FIND v(b_pad) AT=48.45n
.meas tran b19 FIND v(b_pad) AT=50.95n
.meas tran b20 FIND v(b_pad) AT=53.45n
.meas tran b21 FIND v(b_pad) AT=55.95n
.meas tran b22 FIND v(b_pad) AT=58.45n
.meas tran b23 FIND v(b_pad) AT=60.95n
.meas tran b24 FIND v(b_pad) AT=63.45n
.meas tran b25 FIND v(b_pad) AT=65.95n
.meas tran b26 FIND v(b_pad) AT=68.45n
.meas tran b27 FIND v(b_pad) AT=70.95n
.meas tran b28 FIND v(b_pad) AT=73.45n
.meas tran b29 FIND v(b_pad) AT=75.95n
.meas tran b30 FIND v(b_pad) AT=78.45n
.meas tran b31 FIND v(b_pad) AT=80.95n
.meas tran b32 FIND v(b_pad) AT=83.45n
.meas tran b33 FIND v(b_pad) AT=85.95n
.meas tran b34 FIND v(b_pad) AT=88.45n
.end
