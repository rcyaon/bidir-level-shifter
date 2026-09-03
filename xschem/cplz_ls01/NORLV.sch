v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {devices/iopin.sym} -400 0 0 0 {name=p0 lab=a}
C {devices/iopin.sym} -400 60 0 0 {name=p1 lab=b}
C {devices/iopin.sym} -400 120 0 0 {name=p2 lab=y}
C {devices/iopin.sym} -400 180 0 0 {name=p3 lab=vdd}
C {devices/iopin.sym} -400 240 0 0 {name=p4 lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 200 200 0 0 {name=MP1 model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 170 0 0 {name=l1 sig_type=std_logic lab=p1}
C {devices/lab_pin.sym} 180 200 0 0 {name=l2 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 220 230 0 0 {name=l3 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 220 200 0 0 {name=l4 sig_type=std_logic lab=vdd}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 540 200 0 0 {name=MP2 model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 170 0 0 {name=l5 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 520 200 0 0 {name=l6 sig_type=std_logic lab=b}
C {devices/lab_pin.sym} 560 230 0 0 {name=l7 sig_type=std_logic lab=p1}
C {devices/lab_pin.sym} 560 200 0 0 {name=l8 sig_type=std_logic lab=vdd}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 880 200 0 0 {name=MN1 model=sg13_lv_nmos w=0.5u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 170 0 0 {name=l9 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 860 200 0 0 {name=l10 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 900 230 0 0 {name=l11 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 900 200 0 0 {name=l12 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 1220 200 0 0 {name=MN2 model=sg13_lv_nmos w=0.5u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 170 0 0 {name=l13 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 1200 200 0 0 {name=l14 sig_type=std_logic lab=b}
C {devices/lab_pin.sym} 1240 230 0 0 {name=l15 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1240 200 0 0 {name=l16 sig_type=std_logic lab=vss}
