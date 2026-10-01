v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/bidir_channel.sym} 0 0 0 0 {name=XDUT}
C {devices/lab_pin.sym} -140 -40 0 0 {name=l0 sig_type=std_logic lab=a_pad}
C {devices/lab_pin.sym} 140 -10 0 1 {name=l1 sig_type=std_logic lab=b_pad}
C {devices/lab_pin.sym} -140 -20 0 0 {name=l2 sig_type=std_logic lab=dir}
C {devices/lab_pin.sym} -140 0 0 0 {name=l3 sig_type=std_logic lab=oe_n}
C {devices/lab_pin.sym} -140 20 0 0 {name=l4 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} -140 40 0 0 {name=l5 sig_type=std_logic lab=tm}
C {devices/lab_pin.sym} 140 10 0 1 {name=l6 sig_type=std_logic lab=ring_div}
C {devices/lab_pin.sym} -20 -80 0 0 {name=l7 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 20 -80 0 1 {name=l8 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 0 80 3 0 {name=l9 sig_type=std_logic lab=0}
T {bidir_channel test mode: tm=1 makes a ring, ring_div = ring / 16} -300 -420 0 0 1 1 {}
C {devices/code_shown.sym} -300 160 0 0 {name=SIM only_toplevel=false value=".lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
VDL vddl 0 1.2
VDH vddh 0 3.3
Ven en 0 PWL(0 0 3n 0 3.5n 1.2)
Voe oe_n 0 0
Vtm tm 0 PWL(0 0 10n 0 10.5n 1.2)
Vdir dir 0 0
Va adrv 0 0
Vactl actl 0 0
Vb bdrv 0 0
Vbctl bctl 0 0
SA adrv a_pad actl 0 SWA
.model SWA SW(Ron=50 Roff=1G Vt=0.6 Vh=0.05)
SB bdrv b_pad bctl 0 SWB
.model SWB SW(Ron=50 Roff=1G Vt=0.6 Vh=0.05)
CA a_pad 0 5p
CB b_pad 0 5p
CR ring_div 0 1p
.control
save all
tran 20p 600n
meas tran t_ring trig v(b_pad) val=1.65 rise=5 targ v(b_pad) val=1.65 rise=6
meas tran t_div trig v(ring_div) val=0.6 rise=2 targ v(ring_div) val=0.6 rise=3
write tb_bidir_testmode.raw
.endc"}
B 2 400 -300 1500 -110 {flags=graph
y1=-0.1
y2=1.3
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=6e-07
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="tm"
color="4"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_bidir_testmode.raw
sim_type=tran
autoload=1
linewidth_mult=4}
B 2 400 -100 1500 90 {flags=graph
y1=-0.1
y2=3.5
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=6e-07
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="b_pad"
color="10"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_bidir_testmode.raw
sim_type=tran
autoload=1
linewidth_mult=4}
B 2 400 100 1500 290 {flags=graph
y1=-0.1
y2=1.3
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=6e-07
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="ring_div"
color="7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_bidir_testmode.raw
sim_type=tran
autoload=1
linewidth_mult=4}
