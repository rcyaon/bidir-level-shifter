* TB2 -- CPLZ-LS01 reverse path B(3.3V) -> A(1.2V), real PDK models
.include cplz_ls01_dut.spice
.include models_sf.spice
.param VL='1.2*1.1' VH='3.3*1.1' CL=5p
.temp -40

VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir  dir  0 {VL}     $ dir=1 -> reverse B->A
Voe   oe_n 0 0
Ven   en   0 {VL}
Vtm   tm   0 0

Vb b_pad 0 PULSE(0 {VH} 20n 0.3n 0.3n 9.7n 20n)
CA a_pad 0 {CL}

XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH

.tran 20p 200n
.meas tran tpdlh  TRIG v(b_pad) VAL='VH/2' RISE=3 TARG v(a_pad) VAL='VL/2' RISE=3
.meas tran tpdhl  TRIG v(b_pad) VAL='VH/2' FALL=3 TARG v(a_pad) VAL='VL/2' FALL=3
.meas tran trise  TRIG v(a_pad) VAL='0.1*VL' RISE=3 TARG v(a_pad) VAL='0.9*VL' RISE=3
.meas tran tfall  TRIG v(a_pad) VAL='0.9*VL' FALL=3 TARG v(a_pad) VAL='0.1*VL' FALL=3
.meas tran voh    MIN v(a_pad) FROM=108.5n TO=109.8n
.meas tran vol    MAX v(a_pad) FROM=118.5n TO=119.8n
.meas tran iddh_avg AVG i(VDH) FROM=40n TO=160n
.meas tran iddl_avg AVG i(VDL) FROM=40n TO=160n
.end
