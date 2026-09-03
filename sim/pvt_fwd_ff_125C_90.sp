* TB1 -- CPLZ-LS01 forward path A(1.2V) -> B(3.3V), real PDK models
.include cplz_ls01_dut.spice
.include models_ff.spice
.param VL='1.2*0.9' VH='3.3*0.9' CL=5p
.temp 125

VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir  dir  0 0        $ dir=0 -> forward A->B
Voe   oe_n 0 0        $ output enable active low
Ven   en   0 {VL}
Vtm   tm   0 0

* a_pad driven externally (internal A-side drivers are off in forward mode)
Va a_pad 0 PULSE(0 {VL} 20n 0.2n 0.2n 9.8n 20n)
CB b_pad 0 {CL}

XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH

.tran 20p 200n
.meas tran tpdlh  TRIG v(a_pad) VAL='VL/2' RISE=3 TARG v(b_pad) VAL='VH/2' RISE=3
.meas tran tpdhl  TRIG v(a_pad) VAL='VL/2' FALL=3 TARG v(b_pad) VAL='VH/2' FALL=3
.meas tran trise  TRIG v(b_pad) VAL='0.1*VH' RISE=3 TARG v(b_pad) VAL='0.9*VH' RISE=3
.meas tran tfall  TRIG v(b_pad) VAL='0.9*VH' FALL=3 TARG v(b_pad) VAL='0.1*VH' FALL=3
.meas tran voh    MIN v(b_pad) FROM=108.5n TO=109.8n
.meas tran vol    MAX v(b_pad) FROM=118.5n TO=119.8n
.meas tran iddh_avg AVG i(VDH) FROM=40n TO=160n
.meas tran iddl_avg AVG i(VDL) FROM=40n TO=160n
.end
