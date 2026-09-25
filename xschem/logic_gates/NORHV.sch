v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -200 -280 20 -280 {}
N 20 -280 50 -280 {}
N -200 160 20 160 {}
N 20 160 50 160 {}
N 50 160 160 160 {}
N 160 160 190 160 {}
N 20 -280 20 -250 {}
N 20 -100 50 -100 {}
N 50 -220 50 -100 {}
N 50 -280 50 -220 {}
N 20 -220 50 -220 {}
N 20 -190 20 -130 {}
N 20 110 20 160 {}
N 20 80 50 80 {}
N 50 80 50 160 {}
N 160 110 160 160 {}
N 160 80 190 80 {}
N 190 80 190 160 {}
N 20 -70 20 -40 {}
N 20 -40 20 50 {}
N 20 -40 160 -40 {}
N 160 -40 280 -40 {}
N 160 -40 160 50 {}
N -200 -220 -100 -220 {}
N -100 -220 -20 -220 {}
N -100 -220 -100 80 {}
N -100 80 -20 80 {}
N -200 -100 -60 -100 {}
N -60 -100 -20 -100 {}
N -60 -100 -60 0 {}
N -60 0 100 0 {}
N 100 0 100 80 {}
N 100 80 120 80 {}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 0 -220 0 0 {name=MP1 model=sg13_hv_pmos w=4.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 0 -100 0 0 {name=MP2 model=sg13_hv_pmos w=4.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 0 80 0 0 {name=MN1 model=sg13_hv_nmos w=1.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 140 80 0 0 {name=MN2 model=sg13_hv_nmos w=1.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/iopin.sym} -200 -280 0 1 {name=p0 lab=vdd}
C {devices/iopin.sym} -200 160 0 1 {name=p1 lab=vss}
C {devices/iopin.sym} 280 -40 0 0 {name=p2 lab=y}
C {devices/iopin.sym} -200 -220 0 1 {name=p3 lab=a}
C {devices/iopin.sym} -200 -100 0 1 {name=p4 lab=b}
