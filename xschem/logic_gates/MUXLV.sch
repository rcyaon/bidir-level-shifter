v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 20 0 40 0 {}
N 120 0 140 0 {}
N 20 -80 20 -30 {}
N 140 -80 140 -30 {}
N 20 30 20 60 {}
N 20 60 80 60 {}
N 80 60 140 60 {}
N 140 30 140 60 {}
N 320 0 340 0 {}
N 420 0 440 0 {}
N 320 -80 320 -30 {}
N 440 -80 440 -30 {}
N 320 30 320 60 {}
N 320 60 380 60 {}
N 380 60 440 60 {}
N 440 30 440 60 {}
N 20 -80 140 -80 {}
N 140 -80 320 -80 {}
N 320 -80 440 -80 {}
N 440 -80 620 -80 {}
N 180 0 230 0 {}
N 230 0 280 0 {}
N 80 60 80 160 {}
N -300 160 80 160 {}
N 380 60 380 240 {}
N -300 240 380 240 {}
N 230 0 230 200 {}
N -260 200 230 200 {}
N -300 200 -260 200 {}
N -60 0 -20 0 {}
N -60 -200 -60 0 {}
N -100 -200 -60 -200 {}
N -60 -200 560 -200 {}
N 560 -200 560 0 {}
N 480 0 560 0 {}
N -260 -200 -260 200 {}
N -260 -200 -240 -200 {}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 0 0 0 {name=MT0N model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 160 0 2 0 {name=MT0P model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 40 0 0 1 {name=l0 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 120 0 0 0 {name=l1 sig_type=std_logic lab=vdd}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 300 0 0 0 {name=MT1N model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 460 0 2 0 {name=MT1P model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 340 0 0 1 {name=l2 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 420 0 0 0 {name=l3 sig_type=std_logic lab=vdd}
C {devices/iopin.sym} 620 -80 0 0 {name=p0 lab=out}
C {devices/iopin.sym} -300 160 0 1 {name=p1 lab=in0}
C {devices/iopin.sym} -300 240 0 1 {name=p2 lab=in1}
C {devices/iopin.sym} -300 200 0 1 {name=p3 lab=sel}
C {logic_gates/sg13cmos5l_inv_1.sym} -170 -200 0 0 {name=XI}
C {devices/lab_pin.sym} -170 -250 1 0 {name=l4 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} -170 -150 3 0 {name=l5 sig_type=std_logic lab=vss}
C {devices/iopin.sym} -300 -300 0 1 {name=p4 lab=vdd}
C {devices/iopin.sym} -300 -260 0 1 {name=p5 lab=vss}
