v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 130 0 130 40 {}
N 390 0 390 40 {}
N 650 0 650 40 {}
N 910 0 910 40 {}
N 70 0 130 0 {}
N 130 0 190 0 {}
N 330 0 390 0 {}
N 390 0 450 0 {}
N 590 0 650 0 {}
N 650 0 710 0 {}
N -240 0 -70 0 {}
N 850 0 910 0 {}
N 910 0 1020 0 {}
N 0 -120 0 -50 {}
N 0 50 0 120 {}
N 260 -120 260 -50 {}
N 260 50 260 120 {}
N 520 -120 520 -50 {}
N 520 50 520 120 {}
N 780 -120 780 -50 {}
N 780 50 780 120 {}
N -240 -120 0 -120 {}
N 0 -120 260 -120 {}
N 260 -120 520 -120 {}
N 520 -120 780 -120 {}
N -240 120 0 120 {}
N 0 120 130 120 {}
N 130 120 260 120 {}
N 260 120 390 120 {}
N 390 120 520 120 {}
N 520 120 650 120 {}
N 650 120 780 120 {}
N 780 120 910 120 {}
N 130 100 130 120 {}
N 390 100 390 120 {}
N 650 100 650 120 {}
N 910 100 910 120 {}
C {logic_gates/sg13cmos5l_inv_1.sym} 0 0 0 0 {name=X1}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 150 40 0 0 {name=MC1 model=sg13_lv_nmos w=7.4u l=6u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 170 10 0 1 {name=l101 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 170 40 0 1 {name=l102 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 170 70 0 1 {name=l103 sig_type=std_logic lab=vss}
C {logic_gates/sg13cmos5l_inv_1.sym} 260 0 0 0 {name=X2}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 410 40 0 0 {name=MC2 model=sg13_lv_nmos w=7.4u l=6u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 430 10 0 1 {name=l104 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 430 40 0 1 {name=l105 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 430 70 0 1 {name=l106 sig_type=std_logic lab=vss}
C {logic_gates/sg13cmos5l_inv_1.sym} 520 0 0 0 {name=X3}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 670 40 0 0 {name=MC3 model=sg13_lv_nmos w=7.4u l=6u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 690 10 0 1 {name=l107 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 690 40 0 1 {name=l108 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 690 70 0 1 {name=l109 sig_type=std_logic lab=vss}
C {logic_gates/sg13cmos5l_inv_1.sym} 780 0 0 0 {name=X4}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 930 40 0 0 {name=MC4 model=sg13_lv_nmos w=3.2u l=6u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 950 10 0 1 {name=l110 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 950 40 0 1 {name=l111 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 950 70 0 1 {name=l112 sig_type=std_logic lab=vss}
C {devices/iopin.sym} -240 0 0 1 {name=p0 lab=a}
C {devices/iopin.sym} 1020 0 0 0 {name=p1 lab=y}
C {devices/iopin.sym} -240 -120 0 1 {name=p2 lab=vdd}
C {devices/iopin.sym} -240 120 0 1 {name=p3 lab=vss}
