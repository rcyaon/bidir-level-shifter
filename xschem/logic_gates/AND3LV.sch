v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 70 0 170 0 {}
N -240 -20 -70 -20 {}
N -240 0 -70 0 {}
N -240 20 -70 20 {}
N 310 0 400 0 {}
N 0 -120 0 -60 {}
N 0 60 0 120 {}
N 240 -120 240 -50 {}
N 240 50 240 120 {}
N -240 -120 0 -120 {}
N 0 -120 240 -120 {}
N -240 120 0 120 {}
N 0 120 240 120 {}
C {logic_gates/NAND3LV.sym} 0 0 0 0 {name=X1}
C {logic_gates/INVLV.sym} 240 0 0 0 {name=X2}
C {devices/iopin.sym} -240 -20 0 1 {name=p0 lab=a}
C {devices/iopin.sym} -240 0 0 1 {name=p1 lab=b}
C {devices/iopin.sym} -240 20 0 1 {name=p2 lab=c}
C {devices/iopin.sym} 400 0 0 0 {name=p3 lab=y}
C {devices/iopin.sym} -240 -120 0 1 {name=p4 lab=vdd}
C {devices/iopin.sym} -240 120 0 1 {name=p5 lab=vss}
