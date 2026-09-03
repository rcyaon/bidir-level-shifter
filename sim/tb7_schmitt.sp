* TB7 -- SCHMLV input receiver: hysteresis trip points (quasi-DC triangle)
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2
.temp 27
VDD vdd 0 {VL}
Va  a   0 PWL(0 0  1u {VL}  2u 0)
X1 a y vdd 0 SCHMLV
CL y 0 10f
.tran 200p 2u
.meas tran vih FIND v(a) WHEN v(y)='VL/2' FALL=1
.meas tran vil FIND v(a) WHEN v(y)='VL/2' RISE=1
.meas tran vhyst PARAM='vih-vil'
.end
