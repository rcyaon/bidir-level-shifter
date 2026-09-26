v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/level_shifter_up.sym} 0 0 0 0 {name=XDUT}
C {devices/lab_pin.sym} -120 0 0 0 {name=l0 sig_type=std_logic lab=in}
C {devices/lab_pin.sym} 120 -10 0 1 {name=l1 sig_type=std_logic lab=q_h}
C {devices/lab_pin.sym} 120 10 0 1 {name=l2 sig_type=std_logic lab=qb_h}
C {devices/lab_pin.sym} -20 -50 0 0 {name=l3 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 20 -50 0 1 {name=l4 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 0 50 3 0 {name=l5 sig_type=std_logic lab=0}
T {level_shifter_up: 1.2 V in, full 3.3 V out} -300 -420 0 0 1 1 {}
C {devices/code_shown.sym} -300 160 0 0 {name=SIM only_toplevel=false value=".lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
VDL vddl 0 1.2
VDH vddh 0 3.3
VIN in 0 PULSE(0 1.2 5n 0.2n 0.2n 9.8n 20n)
CQ q_h 0 10f
CQB qb_h 0 10f
.control
save all
tran 10p 60n
meas tran tpd_r trig v(in) val=0.6 rise=1 targ v(q_h) val=1.65 rise=1
meas tran tpd_f trig v(in) val=0.6 fall=1 targ v(q_h) val=1.65 fall=1
meas tran i_static avg i(VDH) from=12n to=14n
write tb_level_shifter_up.raw
.endc"}
B 2 400 -300 1500 -110 {flags=graph
y1=-0.1
y2=3.5
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=6e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="in"
color="4"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_level_shifter_up.raw
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
x2=6e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="q_h
qb_h"
color="7 10"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_level_shifter_up.raw
sim_type=tran
autoload=1
linewidth_mult=4}
B 2 400 100 1500 290 {flags=graph
y1=-0.0001
y2=2e-05
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=6e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="i(vdh)"
color="12"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_level_shifter_up.raw
sim_type=tran
autoload=1
linewidth_mult=4}
