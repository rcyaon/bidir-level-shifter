* TB12 WHATIF 2x pull-up -- rev PRBS5, UI=4 ns (250 Mb/s), DUT=cplz_ls01_dut_pmos2x.spice
.include cplz_ls01_dut_pmos2x.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 {VL}
Voe oe_n 0 0
Ven en 0 {VL}
Vtm tm 0 0
Vsrc b_pad 0 PWL(0 {0*VH} 3.75n {0*VH} 4n {0*VH} 7.75n {0*VH} 8n {1*VH} 11.75n {1*VH} 12n {0*VH} 15.75n {0*VH} 16n {0*VH} 19.75n {0*VH} 20n {0*VH} 23.75n {0*VH} 24n {0*VH} 27.75n {0*VH} 28n {1*VH} 31.75n {1*VH} 32n {0*VH} 35.75n {0*VH} 36n {0*VH} 39.75n {0*VH} 40n {1*VH} 43.75n {1*VH} 44n {0*VH} 47.75n {0*VH} 48n {1*VH} 51.75n {1*VH} 52n {1*VH} 55.75n {1*VH} 56n {0*VH} 59.75n {0*VH} 60n {0*VH} 63.75n {0*VH} 64n {1*VH} 67.75n {1*VH} 68n {1*VH} 71.75n {1*VH} 72n {1*VH} 75.75n {1*VH} 76n {1*VH} 79.75n {1*VH} 80n {1*VH} 83.75n {1*VH} 84n {0*VH} 87.75n {0*VH} 88n {0*VH} 91.75n {0*VH} 92n {0*VH} 95.75n {0*VH} 96n {1*VH} 99.75n {1*VH} 100n {1*VH} 103.75n {1*VH} 104n {0*VH} 107.75n {0*VH} 108n {1*VH} 111.75n {1*VH} 112n {1*VH} 115.75n {1*VH} 116n {1*VH} 119.75n {1*VH} 120n {0*VH} 123.75n {0*VH} 124n {1*VH} 127.75n {1*VH} 128n {0*VH} 131.75n {0*VH} 132n {1*VH} 135.75n {1*VH} 136n {0*VH})
CLD a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 146.6n
.meas tran b02 FIND v(a_pad) AT=12.6n
.meas tran b03 FIND v(a_pad) AT=16.6n
.meas tran b04 FIND v(a_pad) AT=20.6n
.meas tran b05 FIND v(a_pad) AT=24.6n
.meas tran b06 FIND v(a_pad) AT=28.6n
.meas tran b07 FIND v(a_pad) AT=32.6n
.meas tran b08 FIND v(a_pad) AT=36.6n
.meas tran b09 FIND v(a_pad) AT=40.6n
.meas tran b10 FIND v(a_pad) AT=44.6n
.meas tran b11 FIND v(a_pad) AT=48.6n
.meas tran b12 FIND v(a_pad) AT=52.6n
.meas tran b13 FIND v(a_pad) AT=56.6n
.meas tran b14 FIND v(a_pad) AT=60.6n
.meas tran b15 FIND v(a_pad) AT=64.6n
.meas tran b16 FIND v(a_pad) AT=68.6n
.meas tran b17 FIND v(a_pad) AT=72.6n
.meas tran b18 FIND v(a_pad) AT=76.6n
.meas tran b19 FIND v(a_pad) AT=80.6n
.meas tran b20 FIND v(a_pad) AT=84.6n
.meas tran b21 FIND v(a_pad) AT=88.6n
.meas tran b22 FIND v(a_pad) AT=92.6n
.meas tran b23 FIND v(a_pad) AT=96.6n
.meas tran b24 FIND v(a_pad) AT=100.6n
.meas tran b25 FIND v(a_pad) AT=104.6n
.meas tran b26 FIND v(a_pad) AT=108.6n
.meas tran b27 FIND v(a_pad) AT=112.6n
.meas tran b28 FIND v(a_pad) AT=116.6n
.meas tran b29 FIND v(a_pad) AT=120.6n
.meas tran b30 FIND v(a_pad) AT=124.6n
.meas tran b31 FIND v(a_pad) AT=128.6n
.meas tran b32 FIND v(a_pad) AT=132.6n
.meas tran b33 FIND v(a_pad) AT=136.6n
.meas tran b34 FIND v(a_pad) AT=140.6n
.end
