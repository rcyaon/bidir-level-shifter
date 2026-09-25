v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -200 -280 20 -280 {}
N 20 -280 50 -280 {}
N 50 -280 190 -280 {}
N -200 280 20 280 {}
N 20 280 50 280 {}
N 50 280 190 280 {}
N 20 -280 20 -250 {}
N 20 -220 50 -220 {}
N 50 -280 50 -220 {}
N 20 250 20 280 {}
N 20 220 50 220 {}
N 50 220 50 280 {}
N 20 -100 50 -100 {}
N 20 100 50 100 {}
N 20 -190 20 -160 {}
N 20 -160 20 -130 {}
N 20 -160 160 -160 {}
N 20 130 20 160 {}
N 20 160 20 190 {}
N 20 160 160 160 {}
N 20 -70 20 0 {}
N 20 0 20 70 {}
N 160 -130 190 -130 {}
N 190 -280 190 -130 {}
N 160 130 190 130 {}
N 190 130 190 280 {}
N 160 -100 160 -80 {}
N 160 -80 200 -80 {}
N 160 80 160 100 {}
N 160 80 200 80 {}
N 20 0 100 0 {}
N 100 0 300 0 {}
N 100 -130 120 -130 {}
N 100 -130 100 0 {}
N 100 0 100 130 {}
N 100 130 120 130 {}
N -60 -220 -20 -220 {}
N -60 -220 -60 -100 {}
N -60 -100 -60 0 {}
N -60 0 -60 100 {}
N -60 100 -60 220 {}
N -60 220 -20 220 {}
N -60 -100 -20 -100 {}
N -60 100 -20 100 {}
N -200 0 -60 0 {}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 0 -220 0 0 {name=MP1 model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 0 -100 0 0 {name=MP2 model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 100 0 0 {name=MN2 model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 220 0 0 {name=MN1 model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 140 -130 0 0 {name=MPF model=sg13_lv_pmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 140 130 0 0 {name=MNF model=sg13_lv_nmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/iopin.sym} -200 -280 0 1 {name=p0 lab=vdd}
C {devices/iopin.sym} -200 280 0 1 {name=p1 lab=vss}
C {devices/lab_pin.sym} 50 -100 0 1 {name=l0 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 50 100 0 1 {name=l1 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 200 -80 0 1 {name=l2 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 200 80 0 1 {name=l3 sig_type=std_logic lab=vdd}
C {devices/iopin.sym} 300 0 0 0 {name=p2 lab=y}
C {devices/iopin.sym} -200 0 0 1 {name=p3 lab=a}
