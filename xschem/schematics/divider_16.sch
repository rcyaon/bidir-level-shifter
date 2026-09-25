v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -240 10 -70 10 {}
N 70 10 150 10 {}
N 290 10 430 10 {}
N 610 10 650 10 {}
N 650 -100 650 10 {}
N 400 -100 650 -100 {}
N 400 -100 400 -10 {}
N 400 -10 430 -10 {}
N 610 -10 680 -10 {}
N 680 -10 680 10 {}
N 680 10 770 10 {}
N 520 -70 520 -50 {}
N 520 50 520 70 {}
N 950 10 990 10 {}
N 990 -100 990 10 {}
N 740 -100 990 -100 {}
N 740 -100 740 -10 {}
N 740 -10 770 -10 {}
N 950 -10 1020 -10 {}
N 1020 -10 1020 10 {}
N 1020 10 1110 10 {}
N 860 -70 860 -50 {}
N 860 50 860 70 {}
N 1290 10 1330 10 {}
N 1330 -100 1330 10 {}
N 1080 -100 1330 -100 {}
N 1080 -100 1080 -10 {}
N 1080 -10 1110 -10 {}
N 1290 -10 1360 -10 {}
N 1360 -10 1360 10 {}
N 1360 10 1450 10 {}
N 1200 -70 1200 -50 {}
N 1200 50 1200 70 {}
N 1630 10 1670 10 {}
N 1670 -100 1670 10 {}
N 1420 -100 1670 -100 {}
N 1420 -100 1420 -10 {}
N 1420 -10 1450 -10 {}
N 1540 -70 1540 -50 {}
N 1540 50 1540 70 {}
N 1630 -10 1780 -10 {}
N 0 -120 0 -40 {}
N 0 60 0 120 {}
N 220 -120 220 -40 {}
N 220 60 220 120 {}
N -240 -120 0 -120 {}
N 0 -120 220 -120 {}
N -240 120 0 120 {}
N 0 120 220 120 {}
C {logic_gates/INVLV.sym} 0 10 0 0 {name=XB1}
C {logic_gates/INVLV.sym} 220 10 0 0 {name=XB2}
C {schematics/dff_c2mos.sym} 520 0 0 0 {name=X1}
C {schematics/dff_c2mos.sym} 860 0 0 0 {name=X2}
C {schematics/dff_c2mos.sym} 1200 0 0 0 {name=X3}
C {schematics/dff_c2mos.sym} 1540 0 0 0 {name=X4}
C {devices/iopin.sym} -240 10 0 1 {name=p0 lab=in}
C {devices/lab_pin.sym} 520 -70 0 0 {name=l0 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 520 70 0 0 {name=l1 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 860 -70 0 0 {name=l2 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 860 70 0 0 {name=l3 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1200 -70 0 0 {name=l4 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1200 70 0 0 {name=l5 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1540 -70 0 0 {name=l6 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1540 70 0 0 {name=l7 sig_type=std_logic lab=vss}
C {devices/iopin.sym} 1780 -10 0 0 {name=p1 lab=out}
C {devices/iopin.sym} -240 -120 0 1 {name=p2 lab=vdd}
C {devices/iopin.sym} -240 120 0 1 {name=p3 lab=vss}
