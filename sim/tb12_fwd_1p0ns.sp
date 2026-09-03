* TB12 -- fwd PRBS5, UI=1.0 ns (1000 Mb/s), DUT=cplz_ls01_dut.spice
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
Vsrc a_pad 0 PWL(0 {0*VL} 0.85n {0*VL} 1n {0*VL} 1.85n {0*VL} 2n {1*VL} 2.85n {1*VL} 3n {0*VL} 3.85n {0*VL} 4n {0*VL} 4.85n {0*VL} 5n {0*VL} 5.85n {0*VL} 6n {0*VL} 6.85n {0*VL} 7n {1*VL} 7.85n {1*VL} 8n {0*VL} 8.85n {0*VL} 9n {0*VL} 9.85n {0*VL} 10n {1*VL} 10.85n {1*VL} 11n {0*VL} 11.85n {0*VL} 12n {1*VL} 12.85n {1*VL} 13n {1*VL} 13.85n {1*VL} 14n {0*VL} 14.85n {0*VL} 15n {0*VL} 15.85n {0*VL} 16n {1*VL} 16.85n {1*VL} 17n {1*VL} 17.85n {1*VL} 18n {1*VL} 18.85n {1*VL} 19n {1*VL} 19.85n {1*VL} 20n {1*VL} 20.85n {1*VL} 21n {0*VL} 21.85n {0*VL} 22n {0*VL} 22.85n {0*VL} 23n {0*VL} 23.85n {0*VL} 24n {1*VL} 24.85n {1*VL} 25n {1*VL} 25.85n {1*VL} 26n {0*VL} 26.85n {0*VL} 27n {1*VL} 27.85n {1*VL} 28n {1*VL} 28.85n {1*VL} 29n {1*VL} 29.85n {1*VL} 30n {0*VL} 30.85n {0*VL} 31n {1*VL} 31.85n {1*VL} 32n {0*VL} 32.85n {0*VL} 33n {1*VL} 33.85n {1*VL} 34n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 38.2n
.meas tran b02 FIND v(b_pad) AT=4.7n
.meas tran b03 FIND v(b_pad) AT=5.7n
.meas tran b04 FIND v(b_pad) AT=6.7n
.meas tran b05 FIND v(b_pad) AT=7.7n
.meas tran b06 FIND v(b_pad) AT=8.7n
.meas tran b07 FIND v(b_pad) AT=9.7n
.meas tran b08 FIND v(b_pad) AT=10.7n
.meas tran b09 FIND v(b_pad) AT=11.7n
.meas tran b10 FIND v(b_pad) AT=12.7n
.meas tran b11 FIND v(b_pad) AT=13.7n
.meas tran b12 FIND v(b_pad) AT=14.7n
.meas tran b13 FIND v(b_pad) AT=15.7n
.meas tran b14 FIND v(b_pad) AT=16.7n
.meas tran b15 FIND v(b_pad) AT=17.7n
.meas tran b16 FIND v(b_pad) AT=18.7n
.meas tran b17 FIND v(b_pad) AT=19.7n
.meas tran b18 FIND v(b_pad) AT=20.7n
.meas tran b19 FIND v(b_pad) AT=21.7n
.meas tran b20 FIND v(b_pad) AT=22.7n
.meas tran b21 FIND v(b_pad) AT=23.7n
.meas tran b22 FIND v(b_pad) AT=24.7n
.meas tran b23 FIND v(b_pad) AT=25.7n
.meas tran b24 FIND v(b_pad) AT=26.7n
.meas tran b25 FIND v(b_pad) AT=27.7n
.meas tran b26 FIND v(b_pad) AT=28.7n
.meas tran b27 FIND v(b_pad) AT=29.7n
.meas tran b28 FIND v(b_pad) AT=30.7n
.meas tran b29 FIND v(b_pad) AT=31.7n
.meas tran b30 FIND v(b_pad) AT=32.7n
.meas tran b31 FIND v(b_pad) AT=33.7n
.meas tran b32 FIND v(b_pad) AT=34.7n
.meas tran b33 FIND v(b_pad) AT=35.7n
.meas tran b34 FIND v(b_pad) AT=36.7n
.end
