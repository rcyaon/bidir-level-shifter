v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -160 -140 20 -140 {}
N 20 -140 50 -140 {}
N -160 140 20 140 {}
N 20 140 50 140 {}
N 20 -140 20 -110 {}
N 20 -80 50 -80 {}
N 50 -140 50 -80 {}
N 20 110 20 140 {}
N 20 80 50 80 {}
N 50 80 50 140 {}
N 20 -50 20 0 {}
N 20 0 20 50 {}
N 20 0 140 0 {}
N -60 -80 -20 -80 {}
N -60 -80 -60 0 {}
N -60 0 -60 80 {}
N -60 80 -20 80 {}
N -160 0 -60 0 {}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 0 -80 0 0 {name=MP model=sg13_hv_pmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 0 80 0 0 {name=MN model=sg13_hv_nmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/iopin.sym} -160 -140 0 1 {name=p0 lab=vdd}
C {devices/iopin.sym} -160 140 0 1 {name=p1 lab=vss}
C {devices/iopin.sym} 140 0 0 0 {name=p2 lab=y}
C {devices/iopin.sym} -160 0 0 1 {name=p3 lab=a}
