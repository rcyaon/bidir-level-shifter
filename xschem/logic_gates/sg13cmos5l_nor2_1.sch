v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 0 0 0 {name=MN0 model=sg13_lv_nmos w=0.74u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 20 -30 0 0 {name=l1 sig_type=std_logic lab=Y}
C {devices/lab_pin.sym} 20 30 0 0 {name=l2 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -20 0 0 0 {name=l3 sig_type=std_logic lab=A}
C {devices/lab_pin.sym} 20 0 0 0 {name=l4 sig_type=std_logic lab=VSS}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 300 0 0 0 {name=MN1 model=sg13_lv_nmos w=0.74u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 320 -30 0 0 {name=l5 sig_type=std_logic lab=Y}
C {devices/lab_pin.sym} 320 30 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 280 0 0 0 {name=l7 sig_type=std_logic lab=B}
C {devices/lab_pin.sym} 320 0 0 0 {name=l8 sig_type=std_logic lab=VSS}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 600 0 0 0 {name=MP0 model=sg13_lv_pmos w=1.12u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 620 -30 0 0 {name=l9 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 620 30 0 0 {name=l10 sig_type=std_logic lab=net1}
C {devices/lab_pin.sym} 580 0 0 0 {name=l11 sig_type=std_logic lab=A}
C {devices/lab_pin.sym} 620 0 0 0 {name=l12 sig_type=std_logic lab=VDD}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 900 0 0 0 {name=MP1 model=sg13_lv_pmos w=1.12u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 920 -30 0 0 {name=l13 sig_type=std_logic lab=net1}
C {devices/lab_pin.sym} 920 30 0 0 {name=l14 sig_type=std_logic lab=Y}
C {devices/lab_pin.sym} 880 0 0 0 {name=l15 sig_type=std_logic lab=B}
C {devices/lab_pin.sym} 920 0 0 0 {name=l16 sig_type=std_logic lab=VDD}
C {devices/iopin.sym} -200 0 0 1 {name=p0 lab=Y}
C {devices/iopin.sym} -200 40 0 1 {name=p1 lab=A}
C {devices/iopin.sym} -200 80 0 1 {name=p2 lab=B}
C {devices/iopin.sym} -200 120 0 1 {name=p3 lab=VDD}
C {devices/iopin.sym} -200 160 0 1 {name=p4 lab=VSS}
