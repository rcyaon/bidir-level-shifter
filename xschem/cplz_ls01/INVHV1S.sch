v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {devices/iopin.sym} -400 0 0 0 {name=p0 lab=a}
C {devices/iopin.sym} -400 60 0 0 {name=p1 lab=y}
C {devices/iopin.sym} -400 120 0 0 {name=p2 lab=vdd}
C {devices/iopin.sym} -400 180 0 0 {name=p3 lab=vss}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 200 200 0 0 {name=MP model=sg13_hv_pmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 170 0 0 {name=l1 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 180 200 0 0 {name=l2 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 220 230 0 0 {name=l3 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 220 200 0 0 {name=l4 sig_type=std_logic lab=vdd}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 540 200 0 0 {name=MN model=sg13_hv_nmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 170 0 0 {name=l5 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 520 200 0 0 {name=l6 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 560 230 0 0 {name=l7 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 560 200 0 0 {name=l8 sig_type=std_logic lab=vss}
