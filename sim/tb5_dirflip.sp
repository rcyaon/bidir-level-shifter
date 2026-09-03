* TB5 -- direction reversal: break-before-make dead time + flip transient current
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3 CL=5p
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Voe  oe_n 0 0
Ven  en   0 {VL}
Vtm  tm   0 0
* dir: 0 (fwd) -> 1 (rev) at 100n -> 0 (fwd) at 200n
Vdir dir 0 PWL(0 0  99.9n 0  100n {VL}  199.9n {VL}  200n 0  300n 0)
CA a_pad 0 {CL}
CB b_pad 0 {CL}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 10p 300n
* fwd->rev flip at 100n: en_up must fall BEFORE en_a rises
.meas tran t_enup_off WHEN v(xch.en_up)='VL/2' FALL=1 TD=99n
.meas tran t_ena_on   WHEN v(xch.en_a)='VL/2'  RISE=1 TD=99n
.meas tran dead_f2r   PARAM='t_ena_on - t_enup_off'
* rev->fwd flip at 200n: en_a must fall BEFORE en_up rises
.meas tran t_ena_off  WHEN v(xch.en_a)='VL/2'  FALL=1 TD=199n
.meas tran t_enup_on  WHEN v(xch.en_up)='VL/2' RISE=1 TD=199n
.meas tran dead_r2f   PARAM='t_enup_on - t_ena_off'
* worst-case supply current excursion through both flips
.meas tran ivddh_pk  MIN i(VDH) FROM=99n TO=210n
.meas tran ivddl_pk  MIN i(VDL) FROM=99n TO=210n
.end
