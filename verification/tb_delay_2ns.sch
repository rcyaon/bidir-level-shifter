v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/delay_2ns.sym} 0 0 0 0 {name=XDUT}
C {devices/lab_pin.sym} -80 0 0 0 {name=l0 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 80 0 0 1 {name=l1 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 0 -50 1 0 {name=l2 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 0 50 3 0 {name=l3 sig_type=std_logic lab=0}
T {delay_2ns: y follows a, a few ns later} -300 -420 0 0 1 1 {}
C {devices/code_shown.sym} -300 160 0 0 {name=SIM only_toplevel=false value=".lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
VDD vdd 0 1.2
VA a 0 PULSE(0 1.2 5n 0.1n 0.1n 10n 20n)
CL y 0 5f
.control
save all
tran 10p 40n
meas tran t_rise trig v(a) val=0.6 rise=1 targ v(y) val=0.6 rise=1
meas tran t_fall trig v(a) val=0.6 fall=1 targ v(y) val=0.6 fall=1
write tb_delay_2ns.raw
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
x2=4e-08
divx=8
subdivx=1
xlabmag=1.4
ylabmag=1.4
node="a
y"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_delay_2ns.raw
sim_type=tran
autoload=1
linewidth_mult=4}
