v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -200 -160 20 -160 {}
N 20 -160 50 -160 {}
N 50 -160 160 -160 {}
N 160 -160 190 -160 {}
N -200 260 20 260 {}
N 20 260 50 260 {}
N 20 -160 20 -130 {}
N 20 -100 50 -100 {}
N 50 -160 50 -100 {}
N 160 -160 160 -130 {}
N 160 -100 190 -100 {}
N 190 -160 190 -100 {}
N 20 230 20 260 {}
N 20 80 50 80 {}
N 50 80 50 200 {}
N 50 200 50 260 {}
N 20 200 50 200 {}
N 20 110 20 170 {}
N 20 -70 20 -20 {}
N 20 -20 20 50 {}
N 160 -70 160 -20 {}
N 20 -20 160 -20 {}
N 160 -20 280 -20 {}
N -200 -100 -60 -100 {}
N -60 -100 -20 -100 {}
N -60 -100 -60 80 {}
N -60 80 -20 80 {}
N -200 200 -100 200 {}
N -100 200 -20 200 {}
N -100 -50 -100 200 {}
N -100 -50 100 -50 {}
N 100 -100 100 -50 {}
N 100 -100 120 -100 {}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 0 -100 0 0 {name=MP1 model=sg13_hv_pmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 140 -100 0 0 {name=MP2 model=sg13_hv_pmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 0 80 0 0 {name=MN1 model=sg13_hv_nmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 0 200 0 0 {name=MN2 model=sg13_hv_nmos w=2.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/iopin.sym} -200 -160 0 1 {name=p0 lab=vdd}
C {devices/iopin.sym} -200 260 0 1 {name=p1 lab=vss}
C {devices/iopin.sym} 280 -20 0 0 {name=p2 lab=y}
C {devices/iopin.sym} -200 -100 0 1 {name=p3 lab=a}
C {devices/iopin.sym} -200 200 0 1 {name=p4 lab=b}
