v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/divider_16.sym} 0 0 0 0 {name=XDUT}
C {devices/lab_pin.sym} -90 0 0 0 {name=l0 sig_type=std_logic lab=in}
C {devices/lab_pin.sym} 90 0 0 1 {name=l1 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 0 -50 1 0 {name=l2 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 0 50 3 0 {name=l3 sig_type=std_logic lab=0}
T {divider_16: one out period = 16 in periods} -300 -420 0 0 1 1 {}
C {devices/code_shown.sym} -300 160 0 0 {name=SIM only_toplevel=false value=".lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
VDD vdd 0 1.2
VIN in 0 PULSE(0 1.2 2n 0.1n 0.1n 2.4n 5n)
CL out 0 5f
.control
save all
tran 10p 200n
meas tran t_in trig v(in) val=0.6 rise=2 targ v(in) val=0.6 rise=3
meas tran t_out trig v(out) val=0.6 rise=1 targ v(out) val=0.6 rise=2
write tb_divider_16.raw
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
x2=2e-07
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
rawfile=$netlist_dir/tb_divider_16.raw
sim_type=tran
autoload=1
linewidth_mult=4}
B 2 400 -100 1500 90 {flags=graph
y1=-0.1
y2=1.3
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=2e-07
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="out"
color="7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_divider_16.raw
sim_type=tran
autoload=1
linewidth_mult=4}
