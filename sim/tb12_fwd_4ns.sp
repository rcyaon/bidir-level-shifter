* TB12 -- fwd PRBS5 integrity, UI=4 ns (250 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc a_pad 0 PWL(0 {0*VL} 3.85n {0*VL} 4n {0*VL} 7.85n {0*VL} 8n {1*VL} 11.85n {1*VL} 12n {0*VL} 15.85n {0*VL} 16n {0*VL} 19.85n {0*VL} 20n {0*VL} 23.85n {0*VL} 24n {0*VL} 27.85n {0*VL} 28n {1*VL} 31.85n {1*VL} 32n {0*VL} 35.85n {0*VL} 36n {0*VL} 39.85n {0*VL} 40n {1*VL} 43.85n {1*VL} 44n {0*VL} 47.85n {0*VL} 48n {1*VL} 51.85n {1*VL} 52n {1*VL} 55.85n {1*VL} 56n {0*VL} 59.85n {0*VL} 60n {0*VL} 63.85n {0*VL} 64n {1*VL} 67.85n {1*VL} 68n {1*VL} 71.85n {1*VL} 72n {1*VL} 75.85n {1*VL} 76n {1*VL} 79.85n {1*VL} 80n {1*VL} 83.85n {1*VL} 84n {0*VL} 87.85n {0*VL} 88n {0*VL} 91.85n {0*VL} 92n {0*VL} 95.85n {0*VL} 96n {1*VL} 99.85n {1*VL} 100n {1*VL} 103.85n {1*VL} 104n {0*VL} 107.85n {0*VL} 108n {1*VL} 111.85n {1*VL} 112n {1*VL} 115.85n {1*VL} 116n {1*VL} 119.85n {1*VL} 120n {0*VL} 123.85n {0*VL} 124n {1*VL} 127.85n {1*VL} 128n {0*VL} 131.85n {0*VL} 132n {1*VL} 135.85n {1*VL} 136n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 146.2n
.meas tran b02 FIND v(b_pad) AT=12.2n
.meas tran b03 FIND v(b_pad) AT=16.2n
.meas tran b04 FIND v(b_pad) AT=20.2n
.meas tran b05 FIND v(b_pad) AT=24.2n
.meas tran b06 FIND v(b_pad) AT=28.2n
.meas tran b07 FIND v(b_pad) AT=32.2n
.meas tran b08 FIND v(b_pad) AT=36.2n
.meas tran b09 FIND v(b_pad) AT=40.2n
.meas tran b10 FIND v(b_pad) AT=44.2n
.meas tran b11 FIND v(b_pad) AT=48.2n
.meas tran b12 FIND v(b_pad) AT=52.2n
.meas tran b13 FIND v(b_pad) AT=56.2n
.meas tran b14 FIND v(b_pad) AT=60.2n
.meas tran b15 FIND v(b_pad) AT=64.2n
.meas tran b16 FIND v(b_pad) AT=68.2n
.meas tran b17 FIND v(b_pad) AT=72.2n
.meas tran b18 FIND v(b_pad) AT=76.2n
.meas tran b19 FIND v(b_pad) AT=80.2n
.meas tran b20 FIND v(b_pad) AT=84.2n
.meas tran b21 FIND v(b_pad) AT=88.2n
.meas tran b22 FIND v(b_pad) AT=92.2n
.meas tran b23 FIND v(b_pad) AT=96.2n
.meas tran b24 FIND v(b_pad) AT=100.2n
.meas tran b25 FIND v(b_pad) AT=104.2n
.meas tran b26 FIND v(b_pad) AT=108.2n
.meas tran b27 FIND v(b_pad) AT=112.2n
.meas tran b28 FIND v(b_pad) AT=116.2n
.meas tran b29 FIND v(b_pad) AT=120.2n
.meas tran b30 FIND v(b_pad) AT=124.2n
.meas tran b31 FIND v(b_pad) AT=128.2n
.meas tran b32 FIND v(b_pad) AT=132.2n
.meas tran b33 FIND v(b_pad) AT=136.2n
.meas tran b34 FIND v(b_pad) AT=140.2n
.end
