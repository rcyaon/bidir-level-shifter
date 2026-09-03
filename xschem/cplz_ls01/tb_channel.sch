v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {cplz_ls01/CH.sym} 300 200 0 0 {name=XCH}
C {devices/lab_pin.sym} 220 200 0 0 {name=l100 sig_type=std_logic lab=a_pad}
C {devices/lab_pin.sym} 220 220 0 0 {name=l101 sig_type=std_logic lab=b_pad}
C {devices/lab_pin.sym} 220 240 0 0 {name=l102 sig_type=std_logic lab=dir}
C {devices/lab_pin.sym} 220 260 0 0 {name=l103 sig_type=std_logic lab=oe_n}
C {devices/lab_pin.sym} 220 280 0 0 {name=l104 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 220 300 0 0 {name=l105 sig_type=std_logic lab=tm}
C {devices/lab_pin.sym} 220 320 0 0 {name=l106 sig_type=std_logic lab=ring_div}
C {devices/lab_pin.sym} 220 340 0 0 {name=l107 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 220 360 0 0 {name=l108 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 220 380 0 0 {name=l109 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 700 60 0 0 {name=STIMULI only_toplevel=false value="* placeholder models -- replace this whole block with the IHP PDK .lib lines
* (.lib cornerMOSlv.lib mos_tt / cornerMOShv.lib mos_tt) inside IIC-OSIC-TOOLS
.model nlv NMOS (LEVEL=1 VTO=0.32  KP=320u GAMMA=0.35 LAMBDA=0.06 CGSO=0.35n CGDO=0.35n)
.model plv PMOS (LEVEL=1 VTO=-0.35 KP=130u GAMMA=0.35 LAMBDA=0.06 CGSO=0.35n CGDO=0.35n)
.model nhv NMOS (LEVEL=1 VTO=0.55  KP=180u GAMMA=0.45 LAMBDA=0.04 CGSO=0.40n CGDO=0.40n)
.model phv PMOS (LEVEL=1 VTO=-0.60 KP=60u  GAMMA=0.45 LAMBDA=0.04 CGSO=0.40n CGDO=0.40n)
.subckt sg13_lv_nmos d g s b w=1u l=0.13u ng=1 m=1
M1 d g s b nlv W=\{w\} L=\{l\} M=\{m\}
.ends
.subckt sg13_lv_pmos d g s b w=1u l=0.13u ng=1 m=1
M1 d g s b plv W=\{w\} L=\{l\} M=\{m\}
.ends
.subckt sg13_hv_nmos d g s b w=1u l=0.45u ng=1 m=1
M1 d g s b nhv W=\{w\} L=\{l\} M=\{m\}
.ends
.subckt sg13_hv_pmos d g s b w=1u l=0.45u ng=1 m=1
M1 d g s b phv W=\{w\} L=\{l\} M=\{m\}
.ends
VDH vddh 0 3.3
VDL vddl 0 1.2
Ven en   0 PWL(0 0 3n 0 3.5n 1.2)
Voe oe_n 0 0
Vtm tm   0 0
Vdir dir 0 PWL(0 0 200n 0 201n 1.2)
Va adrv 0 PULSE(0 1.2 20n 0.3n 0.3n 4.7n 10n)
SA adrv a_pad actl 0 SWA
Vactl actl 0 PWL(0 1.2 198n 1.2 198.5n 0)
.model SWA SW(Ron=50 Roff=1G Vt=0.6 Vh=0.05)
Vb bdrv 0 PULSE(0 3.3 220n 0.5n 0.5n 4.5n 10n)
SB bdrv b_pad bctl 0 SWB
Vbctl bctl 0 PWL(0 0 202n 0 202.5n 1.2)
.model SWB SW(Ron=50 Roff=1G Vt=0.6 Vh=0.05)
CA a_pad 0 5p
CB b_pad 0 5p
.tran 0.05n 400n
.meas tran tpd_up  trig v(a_pad) val=0.6  rise=4        targ v(b_pad) val=1.65 rise=4
.meas tran tpd_dn  trig v(b_pad) val=1.65 rise=2 td=210n targ v(a_pad) val=0.6 rise=2 td=210n
.meas tran iq_up   avg  i(VDH) from=8n to=18n
.meas tran ipk_flip min i(VDH) from=199n to=206n"}
