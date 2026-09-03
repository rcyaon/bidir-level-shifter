* TB10 -- DIV16 standalone: divide ratio and output duty
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 TCK=10n
.temp 27
VDD vdd 0 {VL}
Vck in 0 PULSE(0 {VL} 2n 0.1n 0.1n '{TCK}/2-0.1n' {TCK})
X1 in out vdd 0 DIV16
CLO out 0 50f
.ic v(x1.q1)=0 v(x1.q2)=0 v(x1.q3)=0
.tran 20p 700n
.meas tran to1 WHEN v(out)='VL/2' RISE=2 TD=100n
.meas tran to2 WHEN v(out)='VL/2' RISE=4 TD=100n
.meas tran tout PARAM='(to2-to1)/2'
.meas tran ratio PARAM='((to2-to1)/2)/TCK'
.meas tran vout_pp PP v(out) FROM=300n TO=600n
.meas tran vout_max MAX v(out) FROM=300n TO=600n
.meas tran vout_min MIN v(out) FROM=300n TO=600n
.end
