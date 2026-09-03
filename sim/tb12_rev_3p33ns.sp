* TB12 -- rev PRBS5 integrity, UI=3.33 ns (300 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc b_pad 0 PWL(0 {0*VH} 3.08n {0*VH} 3.33n {0*VH} 6.41n {0*VH} 6.66n {1*VH} 9.74n {1*VH} 9.99n {0*VH} 13.07n {0*VH} 13.32n {0*VH} 16.4n {0*VH} 16.65n {0*VH} 19.73n {0*VH} 19.98n {0*VH} 23.06n {0*VH} 23.31n {1*VH} 26.39n {1*VH} 26.64n {0*VH} 29.72n {0*VH} 29.97n {0*VH} 33.05n {0*VH} 33.3n {1*VH} 36.38n {1*VH} 36.63n {0*VH} 39.71n {0*VH} 39.96n {1*VH} 43.04n {1*VH} 43.29n {1*VH} 46.37n {1*VH} 46.62n {0*VH} 49.7n {0*VH} 49.95n {0*VH} 53.03n {0*VH} 53.28n {1*VH} 56.36n {1*VH} 56.61n {1*VH} 59.69n {1*VH} 59.94n {1*VH} 63.02n {1*VH} 63.27n {1*VH} 66.35n {1*VH} 66.6n {1*VH} 69.68n {1*VH} 69.93n {0*VH} 73.01n {0*VH} 73.26n {0*VH} 76.34n {0*VH} 76.59n {0*VH} 79.67n {0*VH} 79.92n {1*VH} 83n {1*VH} 83.25n {1*VH} 86.33n {1*VH} 86.58n {0*VH} 89.66n {0*VH} 89.91n {1*VH} 92.99n {1*VH} 93.24n {1*VH} 96.32n {1*VH} 96.57n {1*VH} 99.65n {1*VH} 99.9n {0*VH} 102.98n {0*VH} 103.23n {1*VH} 106.31n {1*VH} 106.56n {0*VH} 109.64n {0*VH} 109.89n {1*VH} 112.97n {1*VH} 113.22n {0*VH})
CLD a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 122.48n
.meas tran b02 FIND v(a_pad) AT=10.925n
.meas tran b03 FIND v(a_pad) AT=14.255n
.meas tran b04 FIND v(a_pad) AT=17.585n
.meas tran b05 FIND v(a_pad) AT=20.915n
.meas tran b06 FIND v(a_pad) AT=24.245n
.meas tran b07 FIND v(a_pad) AT=27.575n
.meas tran b08 FIND v(a_pad) AT=30.905n
.meas tran b09 FIND v(a_pad) AT=34.235n
.meas tran b10 FIND v(a_pad) AT=37.565n
.meas tran b11 FIND v(a_pad) AT=40.895n
.meas tran b12 FIND v(a_pad) AT=44.225n
.meas tran b13 FIND v(a_pad) AT=47.555n
.meas tran b14 FIND v(a_pad) AT=50.885n
.meas tran b15 FIND v(a_pad) AT=54.215n
.meas tran b16 FIND v(a_pad) AT=57.545n
.meas tran b17 FIND v(a_pad) AT=60.875n
.meas tran b18 FIND v(a_pad) AT=64.205n
.meas tran b19 FIND v(a_pad) AT=67.535n
.meas tran b20 FIND v(a_pad) AT=70.865n
.meas tran b21 FIND v(a_pad) AT=74.195n
.meas tran b22 FIND v(a_pad) AT=77.525n
.meas tran b23 FIND v(a_pad) AT=80.855n
.meas tran b24 FIND v(a_pad) AT=84.185n
.meas tran b25 FIND v(a_pad) AT=87.515n
.meas tran b26 FIND v(a_pad) AT=90.845n
.meas tran b27 FIND v(a_pad) AT=94.175n
.meas tran b28 FIND v(a_pad) AT=97.505n
.meas tran b29 FIND v(a_pad) AT=100.835n
.meas tran b30 FIND v(a_pad) AT=104.165n
.meas tran b31 FIND v(a_pad) AT=107.495n
.meas tran b32 FIND v(a_pad) AT=110.825n
.meas tran b33 FIND v(a_pad) AT=114.155n
.meas tran b34 FIND v(a_pad) AT=117.485n
.end
