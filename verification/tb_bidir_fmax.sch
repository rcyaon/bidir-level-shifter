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
T {bidir_channel: one toggle rate (here A to B, 100 MHz, 5 pF); fmax_sweep.sh runs the grid} -300 -420 0 0 1 1 {}
C {devices/code_shown.sym} -300 160 0 0 {name=SIM only_toplevel=false value=".lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
VDL vddl 0 1.2
VDH vddh 0 3.3
Ven en 0 PWL(0 0 3n 0 3.5n 1.2)
Voe oe_n 0 0
Vtm tm 0 0
Vdir dir 0 0
Va adrv 0 PULSE(0 1.2 20n 0.1n 0.1n 4.9n 10n)
Vb bdrv 0 PULSE(0 3.3 20n 0.1n 0.1n 4.9n 10n)
* dir = 0: drive a_pad.  dir = 1: drive b_pad.  50 ohm source.
SA adrv a_pad vddl dir SWP
SB bdrv b_pad dir 0 SWP
.model SWP SW(Ron=50 Roff=1G Vt=0.6 Vh=0.05)
CA a_pad 0 5p
CB b_pad 0 5p
CR ring_div 0 1p
* driven pad and copying pad, both scaled to 0..1 of their own supply
Bin in_n 0 V = v(dir) < 0.6 ? v(a_pad)/v(vddl) : v(b_pad)/v(vddh)
Bout out_n 0 V = v(dir) < 0.6 ? v(b_pad)/v(vddh) : v(a_pad)/v(vddl)
.control
* One toggle rate, one direction, one pad load. fmax_sweep.sh edits these
* three lines and runs a grid of them.
let fr = 100e6
let cl = 5e-12
let dv = 0
* Pass: over periods 6-12 the output goes above 90 % and below 10 % of its
* supply and is high 40-60 % of the time.
option trtol=1
save a_pad b_pad in_n out_n
let vl = @vdl[dc]
let vh = @vdh[dc]
let per = 1 / fr
let pw = per / 2 - 0.1n
let t0 = 20n + 6 * per
let t1 = 20n + 12 * per
let ts = per / 200
alter @va[pulse] = [ 0 $&vl 20n 0.1n 0.1n $&pw $&per ]
alter @vb[pulse] = [ 0 $&vh 20n 0.1n 0.1n $&pw $&per ]
alter ca = $&cl
alter cb = $&cl
let vd = dv * vl
alter vdir dc = $&vd
tran $&ts $&t1
meas tran omax max v(out_n) from=$&t0 to=$&t1
meas tran omin min v(out_n) from=$&t0 to=$&t1
meas tran duty avg v(out_n) from=$&t0 to=$&t1
meas tran tplh trig v(in_n) val=0.5 rise=1 td=19n targ v(out_n) val=0.5 rise=1 td=19n
meas tran tphl trig v(in_n) val=0.5 fall=1 td=19n targ v(out_n) val=0.5 fall=1 td=19n
let pass = omax ge 0.9 and omin le 0.1 and duty ge 0.4 and duty le 0.6
echo result fr=$&fr cl=$&cl dir=$&dv pass=$&pass omax=$&omax omin=$&omin duty=$&duty tplh=$&tplh tphl=$&tphl
write tb_bidir_fmax.raw
.endc"}
T {in_n (blue) and out_n (red), each scaled to its own supply} 900 -360 0 0 1 1 {}
B 2 900 -300 3700 280 {flags=graph
y1=-0.1
y2=1.1
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=0
x2=1.4e-07
divx=5
subdivx=1
xlabmag=2.5
ylabmag=2.5
node="in_n
out_n"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_bidir_fmax.raw
sim_type=tran
autoload=1
linewidth_mult=4}
