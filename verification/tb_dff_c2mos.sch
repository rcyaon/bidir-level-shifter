v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/dff_c2mos.sym} 0 0 0 0 {name=XDUT}
C {devices/lab_pin.sym} -90 -10 0 0 {name=l0 sig_type=std_logic lab=d}
C {devices/lab_pin.sym} -90 10 0 0 {name=l1 sig_type=std_logic lab=clk}
C {devices/lab_pin.sym} 90 -10 0 1 {name=l2 sig_type=std_logic lab=q}
C {devices/lab_pin.sym} 90 10 0 1 {name=l3 sig_type=std_logic lab=qb}
C {devices/lab_pin.sym} 0 -50 1 0 {name=l4 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 0 50 3 0 {name=l5 sig_type=std_logic lab=0}
T {dff_c2mos: q takes d on the rising clk edge} -300 -420 0 0 1 1 {}
C {devices/code_shown.sym} -300 160 0 0 {name=SIM only_toplevel=false value=".lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
VDD vdd 0 1.2
VCK clk 0 PULSE(0 1.2 5n 0.1n 0.1n 4.9n 10n)
VD d 0 PWL(0 0 12n 0 12.1n 1.2 33n 1.2 33.1n 0 41n 0 41.1n 1.2 44n 1.2 44.1n 0)
CL q 0 5f
.control
save all
tran 10p 60n
write tb_dff_c2mos.raw
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
x2=6e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="clk"
color="4"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_dff_c2mos.raw
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
x2=6e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="d"
color="7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_dff_c2mos.raw
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
x2=6e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="q
qb"
color="10 12"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_dff_c2mos.raw
sim_type=tran
autoload=1
linewidth_mult=4}
