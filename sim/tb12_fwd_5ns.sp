* TB12 -- fwd PRBS5 integrity, UI=5 ns (200 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc a_pad 0 PWL(0 {0*VL} 4.85n {0*VL} 5n {0*VL} 9.85n {0*VL} 10n {1*VL} 14.85n {1*VL} 15n {0*VL} 19.85n {0*VL} 20n {0*VL} 24.85n {0*VL} 25n {0*VL} 29.85n {0*VL} 30n {0*VL} 34.85n {0*VL} 35n {1*VL} 39.85n {1*VL} 40n {0*VL} 44.85n {0*VL} 45n {0*VL} 49.85n {0*VL} 50n {1*VL} 54.85n {1*VL} 55n {0*VL} 59.85n {0*VL} 60n {1*VL} 64.85n {1*VL} 65n {1*VL} 69.85n {1*VL} 70n {0*VL} 74.85n {0*VL} 75n {0*VL} 79.85n {0*VL} 80n {1*VL} 84.85n {1*VL} 85n {1*VL} 89.85n {1*VL} 90n {1*VL} 94.85n {1*VL} 95n {1*VL} 99.85n {1*VL} 100n {1*VL} 104.85n {1*VL} 105n {0*VL} 109.85n {0*VL} 110n {0*VL} 114.85n {0*VL} 115n {0*VL} 119.85n {0*VL} 120n {1*VL} 124.85n {1*VL} 125n {1*VL} 129.85n {1*VL} 130n {0*VL} 134.85n {0*VL} 135n {1*VL} 139.85n {1*VL} 140n {1*VL} 144.85n {1*VL} 145n {1*VL} 149.85n {1*VL} 150n {0*VL} 154.85n {0*VL} 155n {1*VL} 159.85n {1*VL} 160n {0*VL} 164.85n {0*VL} 165n {1*VL} 169.85n {1*VL} 170n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 182.2n
.meas tran b02 FIND v(b_pad) AT=14.7n
.meas tran b03 FIND v(b_pad) AT=19.7n
.meas tran b04 FIND v(b_pad) AT=24.7n
.meas tran b05 FIND v(b_pad) AT=29.7n
.meas tran b06 FIND v(b_pad) AT=34.7n
.meas tran b07 FIND v(b_pad) AT=39.7n
.meas tran b08 FIND v(b_pad) AT=44.7n
.meas tran b09 FIND v(b_pad) AT=49.7n
.meas tran b10 FIND v(b_pad) AT=54.7n
.meas tran b11 FIND v(b_pad) AT=59.7n
.meas tran b12 FIND v(b_pad) AT=64.7n
.meas tran b13 FIND v(b_pad) AT=69.7n
.meas tran b14 FIND v(b_pad) AT=74.7n
.meas tran b15 FIND v(b_pad) AT=79.7n
.meas tran b16 FIND v(b_pad) AT=84.7n
.meas tran b17 FIND v(b_pad) AT=89.7n
.meas tran b18 FIND v(b_pad) AT=94.7n
.meas tran b19 FIND v(b_pad) AT=99.7n
.meas tran b20 FIND v(b_pad) AT=104.7n
.meas tran b21 FIND v(b_pad) AT=109.7n
.meas tran b22 FIND v(b_pad) AT=114.7n
.meas tran b23 FIND v(b_pad) AT=119.7n
.meas tran b24 FIND v(b_pad) AT=124.7n
.meas tran b25 FIND v(b_pad) AT=129.7n
.meas tran b26 FIND v(b_pad) AT=134.7n
.meas tran b27 FIND v(b_pad) AT=139.7n
.meas tran b28 FIND v(b_pad) AT=144.7n
.meas tran b29 FIND v(b_pad) AT=149.7n
.meas tran b30 FIND v(b_pad) AT=154.7n
.meas tran b31 FIND v(b_pad) AT=159.7n
.meas tran b32 FIND v(b_pad) AT=164.7n
.meas tran b33 FIND v(b_pad) AT=169.7n
.meas tran b34 FIND v(b_pad) AT=174.7n
.end
