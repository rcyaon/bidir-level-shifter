* TB12 -- fwd PRBS5 integrity, UI=3.33 ns (300 Mb/s), mid-eye sampled at tpd+UI/2
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
Vsrc a_pad 0 PWL(0 {0*VL} 3.18n {0*VL} 3.33n {0*VL} 6.51n {0*VL} 6.66n {1*VL} 9.84n {1*VL} 9.99n {0*VL} 13.17n {0*VL} 13.32n {0*VL} 16.5n {0*VL} 16.65n {0*VL} 19.83n {0*VL} 19.98n {0*VL} 23.16n {0*VL} 23.31n {1*VL} 26.49n {1*VL} 26.64n {0*VL} 29.82n {0*VL} 29.97n {0*VL} 33.15n {0*VL} 33.3n {1*VL} 36.48n {1*VL} 36.63n {0*VL} 39.81n {0*VL} 39.96n {1*VL} 43.14n {1*VL} 43.29n {1*VL} 46.47n {1*VL} 46.62n {0*VL} 49.8n {0*VL} 49.95n {0*VL} 53.13n {0*VL} 53.28n {1*VL} 56.46n {1*VL} 56.61n {1*VL} 59.79n {1*VL} 59.94n {1*VL} 63.12n {1*VL} 63.27n {1*VL} 66.45n {1*VL} 66.6n {1*VL} 69.78n {1*VL} 69.93n {0*VL} 73.11n {0*VL} 73.26n {0*VL} 76.44n {0*VL} 76.59n {0*VL} 79.77n {0*VL} 79.92n {1*VL} 83.1n {1*VL} 83.25n {1*VL} 86.43n {1*VL} 86.58n {0*VL} 89.76n {0*VL} 89.91n {1*VL} 93.09n {1*VL} 93.24n {1*VL} 96.42n {1*VL} 96.57n {1*VL} 99.75n {1*VL} 99.9n {0*VL} 103.08n {0*VL} 103.23n {1*VL} 106.41n {1*VL} 106.56n {0*VL} 109.74n {0*VL} 109.89n {1*VL} 113.07n {1*VL} 113.22n {0*VL})
CLD b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 20p 122.08n
.meas tran b02 FIND v(b_pad) AT=10.525n
.meas tran b03 FIND v(b_pad) AT=13.855n
.meas tran b04 FIND v(b_pad) AT=17.185n
.meas tran b05 FIND v(b_pad) AT=20.515n
.meas tran b06 FIND v(b_pad) AT=23.845n
.meas tran b07 FIND v(b_pad) AT=27.175n
.meas tran b08 FIND v(b_pad) AT=30.505n
.meas tran b09 FIND v(b_pad) AT=33.835n
.meas tran b10 FIND v(b_pad) AT=37.165n
.meas tran b11 FIND v(b_pad) AT=40.495n
.meas tran b12 FIND v(b_pad) AT=43.825n
.meas tran b13 FIND v(b_pad) AT=47.155n
.meas tran b14 FIND v(b_pad) AT=50.485n
.meas tran b15 FIND v(b_pad) AT=53.815n
.meas tran b16 FIND v(b_pad) AT=57.145n
.meas tran b17 FIND v(b_pad) AT=60.475n
.meas tran b18 FIND v(b_pad) AT=63.805n
.meas tran b19 FIND v(b_pad) AT=67.135n
.meas tran b20 FIND v(b_pad) AT=70.465n
.meas tran b21 FIND v(b_pad) AT=73.795n
.meas tran b22 FIND v(b_pad) AT=77.125n
.meas tran b23 FIND v(b_pad) AT=80.455n
.meas tran b24 FIND v(b_pad) AT=83.785n
.meas tran b25 FIND v(b_pad) AT=87.115n
.meas tran b26 FIND v(b_pad) AT=90.445n
.meas tran b27 FIND v(b_pad) AT=93.775n
.meas tran b28 FIND v(b_pad) AT=97.105n
.meas tran b29 FIND v(b_pad) AT=100.435n
.meas tran b30 FIND v(b_pad) AT=103.765n
.meas tran b31 FIND v(b_pad) AT=107.095n
.meas tran b32 FIND v(b_pad) AT=110.425n
.meas tran b33 FIND v(b_pad) AT=113.755n
.meas tran b34 FIND v(b_pad) AT=117.085n
.end
