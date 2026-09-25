v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -240 -160 20 -160 {}
N 20 -160 50 -160 {}
N 50 -160 160 -160 {}
N 160 -160 190 -160 {}
N 190 -160 300 -160 {}
N 300 -160 330 -160 {}
N -240 380 20 380 {}
N 20 380 50 380 {}
N 20 -160 20 -130 {}
N 20 -100 50 -100 {}
N 50 -160 50 -100 {}
N 160 -160 160 -130 {}
N 160 -100 190 -100 {}
N 190 -160 190 -100 {}
N 300 -160 300 -130 {}
N 300 -100 330 -100 {}
N 330 -160 330 -100 {}
N 20 350 20 380 {}
N 20 80 50 80 {}
N 50 80 50 200 {}
N 50 200 50 320 {}
N 50 320 50 380 {}
N 20 200 50 200 {}
N 20 320 50 320 {}
N 20 110 20 170 {}
N 20 230 20 290 {}
N 20 -70 20 0 {}
N 20 0 20 50 {}
N 20 0 160 0 {}
N 160 0 300 0 {}
N 300 0 420 0 {}
N 160 -70 160 0 {}
N 300 -70 300 0 {}
N -240 -100 -60 -100 {}
N -60 -100 -20 -100 {}
N -60 -100 -60 80 {}
N -60 80 -20 80 {}
N -240 200 -100 200 {}
N -100 200 -20 200 {}
N -100 -40 -100 200 {}
N -100 -40 100 -40 {}
N 100 -100 100 -40 {}
N 100 -100 120 -100 {}
N -240 320 -140 320 {}
N -140 320 -20 320 {}
N -140 -20 -140 320 {}
N -140 -20 240 -20 {}
N 240 -100 240 -20 {}
N 240 -100 260 -100 {}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 0 -100 0 0 {name=MP1 model=sg13_lv_pmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 140 -100 0 0 {name=MP2 model=sg13_lv_pmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 280 -100 0 0 {name=MP3 model=sg13_lv_pmos w=1.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 80 0 0 {name=MN1 model=sg13_lv_nmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 200 0 0 {name=MN2 model=sg13_lv_nmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 0 320 0 0 {name=MN3 model=sg13_lv_nmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/iopin.sym} -240 -160 0 1 {name=p0 lab=vdd}
C {devices/iopin.sym} -240 380 0 1 {name=p1 lab=vss}
C {devices/iopin.sym} 420 0 0 0 {name=p2 lab=y}
C {devices/iopin.sym} -240 -100 0 1 {name=p3 lab=a}
C {devices/iopin.sym} -240 200 0 1 {name=p4 lab=b}
C {devices/iopin.sym} -240 320 0 1 {name=p5 lab=c}
