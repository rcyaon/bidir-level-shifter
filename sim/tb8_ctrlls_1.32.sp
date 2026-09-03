* TB8 -- CTRLLS LV->HV control level shifter at VDDL=1.32
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.32 VH=3.3
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vin in 0 PULSE(0 {VL} 10n 0.2n 0.2n 20n 40n)
X1 in q_h qb_h vddl vddh 0 CTRLLS
CQ  q_h  0 20f
CQB qb_h 0 20f
.tran 20p 100n
* in HIGH 10.2n-30n ; in LOW 30.2n-50n
.meas tran voh_q  MIN v(q_h)  FROM=25n TO=29n
.meas tran vol_qb MAX v(qb_h) FROM=25n TO=29n
.meas tran vol_q  MAX v(q_h)  FROM=45n TO=49n
.meas tran voh_qb MIN v(qb_h) FROM=45n TO=49n
.meas tran tpd_r  TRIG v(in) VAL='VL/2' RISE=1 TARG v(q_h) VAL='VH/2' RISE=1
.meas tran tpd_f  TRIG v(in) VAL='VL/2' FALL=1 TARG v(q_h) VAL='VH/2' FALL=1
.end
