* TB12 -- rev PRBS5 integrity, UI=2.0 ns (500 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc b_pad 0 PWL(0 {0*VH} 1.75n {0*VH} 2n {0*VH} 3.75n {0*VH} 4n {1*VH} 5.75n {1*VH} 6n {0*VH} 7.75n {0*VH} 8n {0*VH} 9.75n {0*VH} 10n {0*VH} 11.75n {0*VH} 12n {0*VH} 13.75n {0*VH} 14n {1*VH} 15.75n {1*VH} 16n {0*VH} 17.75n {0*VH} 18n {0*VH} 19.75n {0*VH} 20n {1*VH} 21.75n {1*VH} 22n {0*VH} 23.75n {0*VH} 24n {1*VH} 25.75n {1*VH} 26n {1*VH} 27.75n {1*VH} 28n {0*VH} 29.75n {0*VH} 30n {0*VH} 31.75n {0*VH} 32n {1*VH} 33.75n {1*VH} 34n {1*VH} 35.75n {1*VH} 36n {1*VH} 37.75n {1*VH} 38n {1*VH} 39.75n {1*VH} 40n {1*VH} 41.75n {1*VH} 42n {0*VH} 43.75n {0*VH} 44n {0*VH} 45.75n {0*VH} 46n {0*VH} 47.75n {0*VH} 48n {1*VH} 49.75n {1*VH} 50n {1*VH} 51.75n {1*VH} 52n {0*VH} 53.75n {0*VH} 54n {1*VH} 55.75n {1*VH} 56n {1*VH} 57.75n {1*VH} 58n {1*VH} 59.75n {1*VH} 60n {0*VH} 61.75n {0*VH} 62n {1*VH} 63.75n {1*VH} 64n {0*VH} 65.75n {0*VH} 66n {1*VH} 67.75n {1*VH} 68n {0*VH})
CLD a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 74.6n
.meas tran b02 FIND v(a_pad) AT=7.6n
.meas tran b03 FIND v(a_pad) AT=9.6n
.meas tran b04 FIND v(a_pad) AT=11.6n
.meas tran b05 FIND v(a_pad) AT=13.6n
.meas tran b06 FIND v(a_pad) AT=15.6n
.meas tran b07 FIND v(a_pad) AT=17.6n
.meas tran b08 FIND v(a_pad) AT=19.6n
.meas tran b09 FIND v(a_pad) AT=21.6n
.meas tran b10 FIND v(a_pad) AT=23.6n
.meas tran b11 FIND v(a_pad) AT=25.6n
.meas tran b12 FIND v(a_pad) AT=27.6n
.meas tran b13 FIND v(a_pad) AT=29.6n
.meas tran b14 FIND v(a_pad) AT=31.6n
.meas tran b15 FIND v(a_pad) AT=33.6n
.meas tran b16 FIND v(a_pad) AT=35.6n
.meas tran b17 FIND v(a_pad) AT=37.6n
.meas tran b18 FIND v(a_pad) AT=39.6n
.meas tran b19 FIND v(a_pad) AT=41.6n
.meas tran b20 FIND v(a_pad) AT=43.6n
.meas tran b21 FIND v(a_pad) AT=45.6n
.meas tran b22 FIND v(a_pad) AT=47.6n
.meas tran b23 FIND v(a_pad) AT=49.6n
.meas tran b24 FIND v(a_pad) AT=51.6n
.meas tran b25 FIND v(a_pad) AT=53.6n
.meas tran b26 FIND v(a_pad) AT=55.6n
.meas tran b27 FIND v(a_pad) AT=57.6n
.meas tran b28 FIND v(a_pad) AT=59.6n
.meas tran b29 FIND v(a_pad) AT=61.6n
.meas tran b30 FIND v(a_pad) AT=63.6n
.meas tran b31 FIND v(a_pad) AT=65.6n
.meas tran b32 FIND v(a_pad) AT=67.6n
.meas tran b33 FIND v(a_pad) AT=69.6n
.meas tran b34 FIND v(a_pad) AT=71.6n
.end
