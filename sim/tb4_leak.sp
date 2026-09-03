* TB4 -- quiescent / leakage current with channel disabled (en=0, oe_n=1)
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 0
Voe  oe_n 0 {VL}
Ven  en   0 0
Vtm  tm   0 0
* march pads through all four rail combinations, 100ns each
Vaf a_pad 0 PWL(0 0  99.9n 0  100n {VL}  199.9n {VL} 200n 0  299.9n 0 300n {VL})
Vbf b_pad 0 PWL(0 0  199.9n 0  200n {VH} 399n {VH})
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 100p 400n
.meas tran iddl_a0b0 AVG i(VDL) FROM=90n  TO=99n
.meas tran iddh_a0b0 AVG i(VDH) FROM=90n  TO=99n
.meas tran ipad_a0b0 AVG i(Vaf) FROM=90n  TO=99n
.meas tran ipbd_a0b0 AVG i(Vbf) FROM=90n  TO=99n
.meas tran iddl_a1b0 AVG i(VDL) FROM=190n TO=199n
.meas tran iddh_a1b0 AVG i(VDH) FROM=190n TO=199n
.meas tran iddl_a0b1 AVG i(VDL) FROM=290n TO=299n
.meas tran iddh_a0b1 AVG i(VDH) FROM=290n TO=299n
.meas tran iddl_a1b1 AVG i(VDL) FROM=390n TO=399n
.meas tran iddh_a1b1 AVG i(VDH) FROM=390n TO=399n
.meas tran ipad_a1b1 AVG i(Vaf) FROM=390n TO=399n
.meas tran ipbd_a1b1 AVG i(Vbf) FROM=390n TO=399n
.end
