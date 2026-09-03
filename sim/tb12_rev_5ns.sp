* TB12 -- rev PRBS5 integrity, UI=5 ns (200 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc b_pad 0 PWL(0 {0*VH} 4.75n {0*VH} 5n {0*VH} 9.75n {0*VH} 10n {1*VH} 14.75n {1*VH} 15n {0*VH} 19.75n {0*VH} 20n {0*VH} 24.75n {0*VH} 25n {0*VH} 29.75n {0*VH} 30n {0*VH} 34.75n {0*VH} 35n {1*VH} 39.75n {1*VH} 40n {0*VH} 44.75n {0*VH} 45n {0*VH} 49.75n {0*VH} 50n {1*VH} 54.75n {1*VH} 55n {0*VH} 59.75n {0*VH} 60n {1*VH} 64.75n {1*VH} 65n {1*VH} 69.75n {1*VH} 70n {0*VH} 74.75n {0*VH} 75n {0*VH} 79.75n {0*VH} 80n {1*VH} 84.75n {1*VH} 85n {1*VH} 89.75n {1*VH} 90n {1*VH} 94.75n {1*VH} 95n {1*VH} 99.75n {1*VH} 100n {1*VH} 104.75n {1*VH} 105n {0*VH} 109.75n {0*VH} 110n {0*VH} 114.75n {0*VH} 115n {0*VH} 119.75n {0*VH} 120n {1*VH} 124.75n {1*VH} 125n {1*VH} 129.75n {1*VH} 130n {0*VH} 134.75n {0*VH} 135n {1*VH} 139.75n {1*VH} 140n {1*VH} 144.75n {1*VH} 145n {1*VH} 149.75n {1*VH} 150n {0*VH} 154.75n {0*VH} 155n {1*VH} 159.75n {1*VH} 160n {0*VH} 164.75n {0*VH} 165n {1*VH} 169.75n {1*VH} 170n {0*VH})
CLD a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 182.6n
.meas tran b02 FIND v(a_pad) AT=15.1n
.meas tran b03 FIND v(a_pad) AT=20.1n
.meas tran b04 FIND v(a_pad) AT=25.1n
.meas tran b05 FIND v(a_pad) AT=30.1n
.meas tran b06 FIND v(a_pad) AT=35.1n
.meas tran b07 FIND v(a_pad) AT=40.1n
.meas tran b08 FIND v(a_pad) AT=45.1n
.meas tran b09 FIND v(a_pad) AT=50.1n
.meas tran b10 FIND v(a_pad) AT=55.1n
.meas tran b11 FIND v(a_pad) AT=60.1n
.meas tran b12 FIND v(a_pad) AT=65.1n
.meas tran b13 FIND v(a_pad) AT=70.1n
.meas tran b14 FIND v(a_pad) AT=75.1n
.meas tran b15 FIND v(a_pad) AT=80.1n
.meas tran b16 FIND v(a_pad) AT=85.1n
.meas tran b17 FIND v(a_pad) AT=90.1n
.meas tran b18 FIND v(a_pad) AT=95.1n
.meas tran b19 FIND v(a_pad) AT=100.1n
.meas tran b20 FIND v(a_pad) AT=105.1n
.meas tran b21 FIND v(a_pad) AT=110.1n
.meas tran b22 FIND v(a_pad) AT=115.1n
.meas tran b23 FIND v(a_pad) AT=120.1n
.meas tran b24 FIND v(a_pad) AT=125.1n
.meas tran b25 FIND v(a_pad) AT=130.1n
.meas tran b26 FIND v(a_pad) AT=135.1n
.meas tran b27 FIND v(a_pad) AT=140.1n
.meas tran b28 FIND v(a_pad) AT=145.1n
.meas tran b29 FIND v(a_pad) AT=150.1n
.meas tran b30 FIND v(a_pad) AT=155.1n
.meas tran b31 FIND v(a_pad) AT=160.1n
.meas tran b32 FIND v(a_pad) AT=165.1n
.meas tran b33 FIND v(a_pad) AT=170.1n
.meas tran b34 FIND v(a_pad) AT=175.1n
.end
