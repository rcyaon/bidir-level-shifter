* TB13b -- reverse channel DC input threshold / hysteresis (b_pad -> a_pad)
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
Vb b_pad 0 PWL(0 0  2u {VH}  4u 0)
CA a_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 500p 4u
.meas tran vih FIND v(b_pad) WHEN v(a_pad)='VL/2' RISE=1
.meas tran vil FIND v(b_pad) WHEN v(a_pad)='VL/2' FALL=1
.meas tran vhyst PARAM='vih-vil'
.meas tran nm_low  PARAM='vil'
.meas tran nm_high PARAM='VH-vih'
.end
