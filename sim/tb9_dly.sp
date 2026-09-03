* TB9 -- DLY2NS delay cell: does it deliver the ~2 ns it is named for?
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2
.temp 27
VDD vdd 0 {VL}
Va  a   0 PULSE(0 {VL} 5n 0.1n 0.1n 20n 40n)
X1 a y vdd 0 DLY2NS
.tran 10p 100n
.meas tran tdly_r TRIG v(a) VAL='VL/2' RISE=1 TARG v(y) VAL='VL/2' RISE=1
.meas tran tdly_f TRIG v(a) VAL='VL/2' FALL=1 TARG v(y) VAL='VL/2' FALL=1
.end
