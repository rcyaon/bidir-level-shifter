v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {devices/iopin.sym} -400 0 0 0 {name=p0 lab=d}
C {devices/iopin.sym} -400 60 0 0 {name=p1 lab=clk}
C {devices/iopin.sym} -400 120 0 0 {name=p2 lab=q}
C {devices/iopin.sym} -400 180 0 0 {name=p3 lab=qb}
C {devices/iopin.sym} -400 240 0 0 {name=p4 lab=vdd}
C {devices/iopin.sym} -400 300 0 0 {name=p5 lab=vss}
C {cplz_ls01/INVLV.sym} 200 200 0 0 {name=XI0}
C {devices/lab_pin.sym} 120 200 0 0 {name=l1 sig_type=std_logic lab=clk}
C {devices/lab_pin.sym} 120 220 0 0 {name=l2 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 120 240 0 0 {name=l3 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 120 260 0 0 {name=l4 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLV.sym} 540 200 0 0 {name=XI9}
C {devices/lab_pin.sym} 460 200 0 0 {name=l5 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 460 220 0 0 {name=l6 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 460 240 0 0 {name=l7 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 460 260 0 0 {name=l8 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 880 200 0 0 {name=MT1N model=sg13_lv_nmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 170 0 0 {name=l9 sig_type=std_logic lab=m1}
C {devices/lab_pin.sym} 860 200 0 0 {name=l10 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 900 230 0 0 {name=l11 sig_type=std_logic lab=d}
C {devices/lab_pin.sym} 900 200 0 0 {name=l12 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 1220 200 0 0 {name=MT1P model=sg13_lv_pmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 170 0 0 {name=l13 sig_type=std_logic lab=m1}
C {devices/lab_pin.sym} 1200 200 0 0 {name=l14 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 1240 230 0 0 {name=l15 sig_type=std_logic lab=d}
C {devices/lab_pin.sym} 1240 200 0 0 {name=l16 sig_type=std_logic lab=vdd}
C {cplz_ls01/INVLV.sym} 200 480 0 0 {name=XI1}
C {devices/lab_pin.sym} 120 480 0 0 {name=l17 sig_type=std_logic lab=m1}
C {devices/lab_pin.sym} 120 500 0 0 {name=l18 sig_type=std_logic lab=m1b}
C {devices/lab_pin.sym} 120 520 0 0 {name=l19 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 120 540 0 0 {name=l20 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLVW.sym} 540 480 0 0 {name=XI2}
C {devices/lab_pin.sym} 460 480 0 0 {name=l21 sig_type=std_logic lab=m1b}
C {devices/lab_pin.sym} 460 500 0 0 {name=l22 sig_type=std_logic lab=m1f}
C {devices/lab_pin.sym} 460 520 0 0 {name=l23 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 460 540 0 0 {name=l24 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 880 480 0 0 {name=MT2N model=sg13_lv_nmos w=0.3u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 450 0 0 {name=l25 sig_type=std_logic lab=m1}
C {devices/lab_pin.sym} 860 480 0 0 {name=l26 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 900 510 0 0 {name=l27 sig_type=std_logic lab=m1f}
C {devices/lab_pin.sym} 900 480 0 0 {name=l28 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 1220 480 0 0 {name=MT2P model=sg13_lv_pmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 450 0 0 {name=l29 sig_type=std_logic lab=m1}
C {devices/lab_pin.sym} 1200 480 0 0 {name=l30 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 1240 510 0 0 {name=l31 sig_type=std_logic lab=m1f}
C {devices/lab_pin.sym} 1240 480 0 0 {name=l32 sig_type=std_logic lab=vdd}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 200 760 0 0 {name=MT3N model=sg13_lv_nmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 730 0 0 {name=l33 sig_type=std_logic lab=s1}
C {devices/lab_pin.sym} 180 760 0 0 {name=l34 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 220 790 0 0 {name=l35 sig_type=std_logic lab=m1b}
C {devices/lab_pin.sym} 220 760 0 0 {name=l36 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 540 760 0 0 {name=MT3P model=sg13_lv_pmos w=1.2u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 730 0 0 {name=l37 sig_type=std_logic lab=s1}
C {devices/lab_pin.sym} 520 760 0 0 {name=l38 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 560 790 0 0 {name=l39 sig_type=std_logic lab=m1b}
C {devices/lab_pin.sym} 560 760 0 0 {name=l40 sig_type=std_logic lab=vdd}
C {cplz_ls01/INVLV.sym} 880 760 0 0 {name=XI3}
C {devices/lab_pin.sym} 800 760 0 0 {name=l41 sig_type=std_logic lab=s1}
C {devices/lab_pin.sym} 800 780 0 0 {name=l42 sig_type=std_logic lab=s1b}
C {devices/lab_pin.sym} 800 800 0 0 {name=l43 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 800 820 0 0 {name=l44 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLVW.sym} 1220 760 0 0 {name=XI4}
C {devices/lab_pin.sym} 1140 760 0 0 {name=l45 sig_type=std_logic lab=s1b}
C {devices/lab_pin.sym} 1140 780 0 0 {name=l46 sig_type=std_logic lab=s1f}
C {devices/lab_pin.sym} 1140 800 0 0 {name=l47 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1140 820 0 0 {name=l48 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 200 1040 0 0 {name=MT4N model=sg13_lv_nmos w=0.3u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 1010 0 0 {name=l49 sig_type=std_logic lab=s1}
C {devices/lab_pin.sym} 180 1040 0 0 {name=l50 sig_type=std_logic lab=clkb}
C {devices/lab_pin.sym} 220 1070 0 0 {name=l51 sig_type=std_logic lab=s1f}
C {devices/lab_pin.sym} 220 1040 0 0 {name=l52 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 540 1040 0 0 {name=MT4P model=sg13_lv_pmos w=0.6u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 1010 0 0 {name=l53 sig_type=std_logic lab=s1}
C {devices/lab_pin.sym} 520 1040 0 0 {name=l54 sig_type=std_logic lab=clki}
C {devices/lab_pin.sym} 560 1070 0 0 {name=l55 sig_type=std_logic lab=s1f}
C {devices/lab_pin.sym} 560 1040 0 0 {name=l56 sig_type=std_logic lab=vdd}
C {cplz_ls01/INVLV.sym} 880 1040 0 0 {name=XI5}
C {devices/lab_pin.sym} 800 1040 0 0 {name=l57 sig_type=std_logic lab=s1b}
C {devices/lab_pin.sym} 800 1060 0 0 {name=l58 sig_type=std_logic lab=qb}
C {devices/lab_pin.sym} 800 1080 0 0 {name=l59 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 800 1100 0 0 {name=l60 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLV.sym} 1220 1040 0 0 {name=XI6}
C {devices/lab_pin.sym} 1140 1040 0 0 {name=l61 sig_type=std_logic lab=qb}
C {devices/lab_pin.sym} 1140 1060 0 0 {name=l62 sig_type=std_logic lab=q}
C {devices/lab_pin.sym} 1140 1080 0 0 {name=l63 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1140 1100 0 0 {name=l64 sig_type=std_logic lab=vss}
