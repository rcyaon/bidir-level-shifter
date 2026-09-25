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
C {logic_gates/INVLV.sym} 0 0 0 0 {name=X1}
C {devices/capa.sym} 130 70 0 0 {name=C1 value=0.35p footprint=1206 m=1}
C {logic_gates/INVLV.sym} 260 0 0 0 {name=X2}
C {devices/capa.sym} 390 70 0 0 {name=C2 value=0.35p footprint=1206 m=1}
C {logic_gates/INVLV.sym} 520 0 0 0 {name=X3}
C {devices/capa.sym} 650 70 0 0 {name=C3 value=0.35p footprint=1206 m=1}
C {logic_gates/INVLV.sym} 780 0 0 0 {name=X4}
C {devices/capa.sym} 910 70 0 0 {name=C4 value=0.15p footprint=1206 m=1}
C {devices/iopin.sym} -240 0 0 1 {name=p0 lab=a}
C {devices/iopin.sym} 1020 0 0 0 {name=p1 lab=y}
C {devices/iopin.sym} -240 -120 0 1 {name=p2 lab=vdd}
C {devices/iopin.sym} -240 120 0 1 {name=p3 lab=vss}
