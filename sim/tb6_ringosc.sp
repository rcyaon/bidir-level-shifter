* TB6 -- test mode (tm=1): internal ring oscillator + DIV16 divide ratio
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir dir 0 0
Voe  oe_n 0 0
Ven  en   0 {VL}
Vtm  tm   0 {VL}
CA a_pad 0 {CL}
CB b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.ic v(xch.z_l)=0 v(xch.z_h)=0
.tran 20p 2u
* ring period from z_l, divided period from ring_div -> ratio must be 16
.meas tran tz1 WHEN v(xch.z_l)='VL/2' RISE=6  TD=200n
.meas tran tz2 WHEN v(xch.z_l)='VL/2' RISE=26 TD=200n
.meas tran tring PARAM='(tz2-tz1)/20'
.meas tran td1 WHEN v(ring_div)='VL/2' RISE=2 TD=200n
.meas tran td2 WHEN v(ring_div)='VL/2' RISE=4 TD=200n
.meas tran tdiv PARAM='(td2-td1)/2'
.meas tran divratio PARAM='((td2-td1)/2)/((tz2-tz1)/20)'
.meas tran fring PARAM='20/(tz2-tz1)'
.meas tran bpad_pp PP v(b_pad) FROM=500n TO=1.5u
.meas tran apad_pp PP v(a_pad) FROM=500n TO=1.5u
.end
