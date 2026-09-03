* TB13a -- forward channel DC input threshold / hysteresis (a_pad -> b_pad)
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
Va a_pad 0 PWL(0 0  2u {VL}  4u 0)
CB b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 500p 4u
.meas tran vih FIND v(a_pad) WHEN v(b_pad)='VH/2' RISE=1
.meas tran vil FIND v(a_pad) WHEN v(b_pad)='VH/2' FALL=1
.meas tran vhyst PARAM='vih-vil'
.meas tran nm_low  PARAM='vil'
.meas tran nm_high PARAM='VL-vih'
.end
