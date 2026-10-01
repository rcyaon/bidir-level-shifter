v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -80 -220 -50 -220 {}
N -50 -220 -20 -220 {}
N -20 -220 220 -220 {}
N 220 -220 250 -220 {}
N -80 160 -20 160 {}
N -20 160 10 160 {}
N 10 160 190 160 {}
N 190 160 220 160 {}
N -20 -220 -20 -190 {}
N 220 -220 220 -190 {}
N -50 -160 -20 -160 {}
N -50 -220 -50 -160 {}
N 220 -160 250 -160 {}
N 250 -220 250 -160 {}
N -20 -130 -20 -100 {}
N -20 -100 -20 -80 {}
N -20 -80 -20 -70 {}
N -20 -10 -20 50 {}
N -20 110 -20 160 {}
N 220 -130 220 -120 {}
N 220 -120 220 -100 {}
N 220 -100 220 -70 {}
N 220 -10 220 50 {}
N 220 110 220 160 {}
N -20 -40 10 -40 {}
N 10 -40 10 80 {}
N 10 80 10 160 {}
N -20 80 10 80 {}
N 190 -40 220 -40 {}
N 190 -40 190 80 {}
N 190 80 190 160 {}
N 190 80 220 80 {}
N -20 -80 140 -80 {}
N 140 -160 140 -80 {}
N 140 -160 180 -160 {}
N 60 -120 220 -120 {}
N 60 -160 60 -120 {}
N 20 -160 60 -160 {}
N -240 -100 -20 -100 {}
N 220 -100 360 -100 {}
N -240 -40 -60 -40 {}
N 260 -40 290 -40 {}
N -240 80 -140 80 {}
N -140 80 -60 80 {}
N -140 80 -140 260 {}
N -140 260 -70 260 {}
N 70 260 320 260 {}
N 320 80 320 260 {}
N 260 80 320 80 {}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 0 -160 0 1 {name=MP1 model=sg13_hv_pmos w=0.5u l=1.6u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 200 -160 0 0 {name=MP2 model=sg13_hv_pmos w=0.5u l=1.6u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} -40 -40 0 0 {name=MC1 model=sg13_hv_nmos w=1.5u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 240 -40 0 1 {name=MC2 model=sg13_hv_nmos w=1.5u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} -40 80 0 0 {name=MN1 model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 240 80 0 1 {name=MN2 model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/iopin.sym} -80 -220 0 1 {name=p0 lab=vddh}
C {devices/iopin.sym} -80 160 0 1 {name=p1 lab=vss}
C {devices/iopin.sym} -240 -100 0 1 {name=p2 lab=qb_h}
C {devices/iopin.sym} 360 -100 0 0 {name=p3 lab=q_h}
C {devices/iopin.sym} -240 -40 0 1 {name=p4 lab=vddl}
C {devices/lab_pin.sym} 290 -40 0 1 {name=l0 sig_type=std_logic lab=vddl}
C {logic_gates/sg13cmos5l_inv_1.sym} 0 260 0 0 {name=XI}
C {devices/lab_pin.sym} 0 210 1 0 {name=l1 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 0 310 3 0 {name=l2 sig_type=std_logic lab=vss}
C {devices/iopin.sym} -240 80 0 1 {name=p5 lab=in}
