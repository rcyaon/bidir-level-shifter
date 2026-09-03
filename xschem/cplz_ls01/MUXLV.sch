v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {devices/iopin.sym} -400 0 0 0 {name=p0 lab=in0}
C {devices/iopin.sym} -400 60 0 0 {name=p1 lab=in1}
C {devices/iopin.sym} -400 120 0 0 {name=p2 lab=sel}
C {devices/iopin.sym} -400 180 0 0 {name=p3 lab=out}
C {devices/iopin.sym} -400 240 0 0 {name=p4 lab=vdd}
C {devices/iopin.sym} -400 300 0 0 {name=p5 lab=vss}
C {cplz_ls01/INVLV.sym} 200 200 0 0 {name=XI}
C {devices/lab_pin.sym} 120 200 0 0 {name=l1 sig_type=std_logic lab=sel}
C {devices/lab_pin.sym} 120 220 0 0 {name=l2 sig_type=std_logic lab=selb}
C {devices/lab_pin.sym} 120 240 0 0 {name=l3 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 120 260 0 0 {name=l4 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 540 200 0 0 {name=MT0N model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 170 0 0 {name=l5 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 520 200 0 0 {name=l6 sig_type=std_logic lab=selb}
C {devices/lab_pin.sym} 560 230 0 0 {name=l7 sig_type=std_logic lab=in0}
C {devices/lab_pin.sym} 560 200 0 0 {name=l8 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 880 200 0 0 {name=MT0P model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 170 0 0 {name=l9 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 860 200 0 0 {name=l10 sig_type=std_logic lab=sel}
C {devices/lab_pin.sym} 900 230 0 0 {name=l11 sig_type=std_logic lab=in0}
C {devices/lab_pin.sym} 900 200 0 0 {name=l12 sig_type=std_logic lab=vdd}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 1220 200 0 0 {name=MT1N model=sg13_lv_nmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 170 0 0 {name=l13 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 1200 200 0 0 {name=l14 sig_type=std_logic lab=sel}
C {devices/lab_pin.sym} 1240 230 0 0 {name=l15 sig_type=std_logic lab=in1}
C {devices/lab_pin.sym} 1240 200 0 0 {name=l16 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 200 480 0 0 {name=MT1P model=sg13_lv_pmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 450 0 0 {name=l17 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 180 480 0 0 {name=l18 sig_type=std_logic lab=selb}
C {devices/lab_pin.sym} 220 510 0 0 {name=l19 sig_type=std_logic lab=in1}
C {devices/lab_pin.sym} 220 480 0 0 {name=l20 sig_type=std_logic lab=vdd}
