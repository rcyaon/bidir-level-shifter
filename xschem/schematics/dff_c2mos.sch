v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -30 0 -30 160 {}
N 30 0 30 160 {}
N 0 0 0 20 {}
N 0 140 0 160 {}
N 0 -60 0 -40 {}
N 0 200 0 220 {}
N 410 0 410 160 {}
N 470 0 470 160 {}
N 440 0 440 20 {}
N 440 140 440 160 {}
N 440 -60 440 -40 {}
N 440 200 440 220 {}
N 30 300 30 460 {}
N 90 300 90 340 {}
N 90 340 90 460 {}
N 60 300 60 320 {}
N 60 440 60 460 {}
N 60 500 60 520 {}
N 60 240 60 260 {}
N 470 300 470 460 {}
N 530 300 530 340 {}
N 530 340 530 460 {}
N 500 300 500 320 {}
N 500 440 500 460 {}
N 500 500 500 520 {}
N 500 240 500 260 {}
N -240 0 -30 0 {}
N 30 0 150 0 {}
N 290 0 320 0 {}
N 320 0 410 0 {}
N 470 0 590 0 {}
N 730 0 760 0 {}
N 760 0 830 0 {}
N 970 0 1010 0 {}
N 1010 0 1050 0 {}
N 1190 0 1300 0 {}
N 1010 -160 1010 0 {}
N 1010 -160 1300 -160 {}
N 30 160 30 300 {}
N 470 160 470 300 {}
N 320 0 320 340 {}
N 290 340 320 340 {}
N 90 340 150 340 {}
N 760 0 760 340 {}
N 730 340 760 340 {}
N 530 340 590 340 {}
N 220 -70 220 -50 {}
N 220 50 220 70 {}
N 660 -70 660 -50 {}
N 660 50 660 70 {}
N 900 -70 900 -50 {}
N 900 50 900 70 {}
N 1120 -70 1120 -50 {}
N 1120 50 1120 70 {}
N 220 270 220 290 {}
N 220 390 220 410 {}
N 660 270 660 290 {}
N 660 390 660 410 {}
N -240 -260 -70 -260 {}
N 70 -260 130 -260 {}
N 130 -260 190 -260 {}
N 130 -280 130 -260 {}
N 330 -260 380 -260 {}
N 0 -360 0 -310 {}
N 0 -210 0 -160 {}
N 260 -360 260 -310 {}
N 260 -210 260 -160 {}
N -240 -360 0 -360 {}
N 0 -360 260 -360 {}
N -240 -160 0 -160 {}
N 0 -160 260 -160 {}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 -20 1 0 {name=MT1N model=sg13_lv_nmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 0 180 3 0 {name=MT1P model=sg13_lv_pmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 0 20 3 0 {name=l0 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 0 140 1 0 {name=l1 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 0 -60 0 0 {name=l2 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 0 220 0 0 {name=l3 sig_type=std_logic lab=clki}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 440 -20 1 0 {name=MT3N model=sg13_lv_nmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 440 180 3 0 {name=MT3P model=sg13_lv_pmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 440 20 3 0 {name=l4 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 440 140 1 0 {name=l5 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 440 -60 0 0 {name=l6 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 440 220 0 0 {name=l7 sig_type=std_logic lab=clkb}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 60 280 1 0 {name=MT2P model=sg13_lv_pmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 60 480 3 0 {name=MT2N model=sg13_lv_nmos w=0.3u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 60 320 3 0 {name=l8 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 60 440 1 0 {name=l9 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 60 520 0 0 {name=l10 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 60 240 0 0 {name=l11 sig_type=std_logic lab=clkb}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 500 280 1 0 {name=MT4P model=sg13_lv_pmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 500 480 3 0 {name=MT4N model=sg13_lv_nmos w=0.3u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 500 320 3 0 {name=l12 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 500 440 1 0 {name=l13 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 500 520 0 0 {name=l14 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 500 240 0 0 {name=l15 sig_type=std_logic lab=clki}
C {logic_gates/INVLV.sym} 220 0 0 0 {name=XI1}
C {logic_gates/INVLV.sym} 660 0 0 0 {name=XI3}
C {logic_gates/INVLV.sym} 900 0 0 0 {name=XI5}
C {logic_gates/INVLV.sym} 1120 0 0 0 {name=XI6}
C {logic_gates/INVLVW.sym} 220 340 0 1 {name=XI2}
C {logic_gates/INVLVW.sym} 660 340 0 1 {name=XI4}
C {devices/iopin.sym} -240 0 0 1 {name=p0 lab=d}
C {devices/iopin.sym} 1300 0 0 0 {name=p1 lab=q}
C {devices/iopin.sym} 1300 -160 0 0 {name=p2 lab=qb}
C {devices/lab_pin.sym} 220 -70 0 0 {name=l16 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 220 70 0 0 {name=l17 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 660 -70 0 0 {name=l18 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 660 70 0 0 {name=l19 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 900 -70 0 0 {name=l20 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 900 70 0 0 {name=l21 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1120 -70 0 0 {name=l22 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1120 70 0 0 {name=l23 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 220 270 0 0 {name=l24 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 220 410 0 0 {name=l25 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 660 270 0 0 {name=l26 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 660 410 0 0 {name=l27 sig_type=std_logic lab=vss}
C {logic_gates/INVLV.sym} 0 -260 0 0 {name=XI0}
C {logic_gates/INVLV.sym} 260 -260 0 0 {name=XI9}
C {devices/iopin.sym} -240 -260 0 1 {name=p3 lab=clk}
C {devices/lab_pin.sym} 130 -280 0 0 {name=l28 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 380 -260 0 1 {name=l29 sig_type=std_logic lab=clki}
C {devices/iopin.sym} -240 -360 0 1 {name=p4 lab=vdd}
C {devices/iopin.sym} -240 -160 0 1 {name=p5 lab=vss}
