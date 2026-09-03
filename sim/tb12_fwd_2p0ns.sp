* TB12 -- fwd PRBS5 integrity, UI=2.0 ns (500 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc a_pad 0 PWL(0 {0*VL} 1.85n {0*VL} 2n {0*VL} 3.85n {0*VL} 4n {1*VL} 5.85n {1*VL} 6n {0*VL} 7.85n {0*VL} 8n {0*VL} 9.85n {0*VL} 10n {0*VL} 11.85n {0*VL} 12n {0*VL} 13.85n {0*VL} 14n {1*VL} 15.85n {1*VL} 16n {0*VL} 17.85n {0*VL} 18n {0*VL} 19.85n {0*VL} 20n {1*VL} 21.85n {1*VL} 22n {0*VL} 23.85n {0*VL} 24n {1*VL} 25.85n {1*VL} 26n {1*VL} 27.85n {1*VL} 28n {0*VL} 29.85n {0*VL} 30n {0*VL} 31.85n {0*VL} 32n {1*VL} 33.85n {1*VL} 34n {1*VL} 35.85n {1*VL} 36n {1*VL} 37.85n {1*VL} 38n {1*VL} 39.85n {1*VL} 40n {1*VL} 41.85n {1*VL} 42n {0*VL} 43.85n {0*VL} 44n {0*VL} 45.85n {0*VL} 46n {0*VL} 47.85n {0*VL} 48n {1*VL} 49.85n {1*VL} 50n {1*VL} 51.85n {1*VL} 52n {0*VL} 53.85n {0*VL} 54n {1*VL} 55.85n {1*VL} 56n {1*VL} 57.85n {1*VL} 58n {1*VL} 59.85n {1*VL} 60n {0*VL} 61.85n {0*VL} 62n {1*VL} 63.85n {1*VL} 64n {0*VL} 65.85n {0*VL} 66n {1*VL} 67.85n {1*VL} 68n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 74.2n
.meas tran b02 FIND v(b_pad) AT=7.2n
.meas tran b03 FIND v(b_pad) AT=9.2n
.meas tran b04 FIND v(b_pad) AT=11.2n
.meas tran b05 FIND v(b_pad) AT=13.2n
.meas tran b06 FIND v(b_pad) AT=15.2n
.meas tran b07 FIND v(b_pad) AT=17.2n
.meas tran b08 FIND v(b_pad) AT=19.2n
.meas tran b09 FIND v(b_pad) AT=21.2n
.meas tran b10 FIND v(b_pad) AT=23.2n
.meas tran b11 FIND v(b_pad) AT=25.2n
.meas tran b12 FIND v(b_pad) AT=27.2n
.meas tran b13 FIND v(b_pad) AT=29.2n
.meas tran b14 FIND v(b_pad) AT=31.2n
.meas tran b15 FIND v(b_pad) AT=33.2n
.meas tran b16 FIND v(b_pad) AT=35.2n
.meas tran b17 FIND v(b_pad) AT=37.2n
.meas tran b18 FIND v(b_pad) AT=39.2n
.meas tran b19 FIND v(b_pad) AT=41.2n
.meas tran b20 FIND v(b_pad) AT=43.2n
.meas tran b21 FIND v(b_pad) AT=45.2n
.meas tran b22 FIND v(b_pad) AT=47.2n
.meas tran b23 FIND v(b_pad) AT=49.2n
.meas tran b24 FIND v(b_pad) AT=51.2n
.meas tran b25 FIND v(b_pad) AT=53.2n
.meas tran b26 FIND v(b_pad) AT=55.2n
.meas tran b27 FIND v(b_pad) AT=57.2n
.meas tran b28 FIND v(b_pad) AT=59.2n
.meas tran b29 FIND v(b_pad) AT=61.2n
.meas tran b30 FIND v(b_pad) AT=63.2n
.meas tran b31 FIND v(b_pad) AT=65.2n
.meas tran b32 FIND v(b_pad) AT=67.2n
.meas tran b33 FIND v(b_pad) AT=69.2n
.meas tran b34 FIND v(b_pad) AT=71.2n
.end
