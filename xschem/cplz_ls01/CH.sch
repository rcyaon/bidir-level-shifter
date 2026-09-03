v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {devices/iopin.sym} -400 0 0 0 {name=p0 lab=a_pad}
C {devices/iopin.sym} -400 60 0 0 {name=p1 lab=b_pad}
C {devices/iopin.sym} -400 120 0 0 {name=p2 lab=dir}
C {devices/iopin.sym} -400 180 0 0 {name=p3 lab=oe_n}
C {devices/iopin.sym} -400 240 0 0 {name=p4 lab=en}
C {devices/iopin.sym} -400 300 0 0 {name=p5 lab=tm}
C {devices/iopin.sym} -400 360 0 0 {name=p6 lab=ring_div}
C {devices/iopin.sym} -400 420 0 0 {name=p7 lab=vddl}
C {devices/iopin.sym} -400 480 0 0 {name=p8 lab=vddh}
C {devices/iopin.sym} -400 540 0 0 {name=p9 lab=vss}
C {cplz_ls01/INVLV.sym} 200 200 0 0 {name=XU1}
C {devices/lab_pin.sym} 120 200 0 0 {name=l1 sig_type=std_logic lab=dir}
C {devices/lab_pin.sym} 120 220 0 0 {name=l2 sig_type=std_logic lab=dirb}
C {devices/lab_pin.sym} 120 240 0 0 {name=l3 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 260 0 0 {name=l4 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLV.sym} 540 200 0 0 {name=XU2}
C {devices/lab_pin.sym} 460 200 0 0 {name=l5 sig_type=std_logic lab=oe_n}
C {devices/lab_pin.sym} 460 220 0 0 {name=l6 sig_type=std_logic lab=oe}
C {devices/lab_pin.sym} 460 240 0 0 {name=l7 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 460 260 0 0 {name=l8 sig_type=std_logic lab=vss}
C {cplz_ls01/OR2LV.sym} 880 200 0 0 {name=XO1}
C {devices/lab_pin.sym} 800 200 0 0 {name=l9 sig_type=std_logic lab=dirb}
C {devices/lab_pin.sym} 800 220 0 0 {name=l10 sig_type=std_logic lab=tm}
C {devices/lab_pin.sym} 800 240 0 0 {name=l11 sig_type=std_logic lab=dtu}
C {devices/lab_pin.sym} 800 260 0 0 {name=l12 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 800 280 0 0 {name=l13 sig_type=std_logic lab=vss}
C {cplz_ls01/OR2LV.sym} 1220 200 0 0 {name=XO2}
C {devices/lab_pin.sym} 1140 200 0 0 {name=l14 sig_type=std_logic lab=dir}
C {devices/lab_pin.sym} 1140 220 0 0 {name=l15 sig_type=std_logic lab=tm}
C {devices/lab_pin.sym} 1140 240 0 0 {name=l16 sig_type=std_logic lab=dtd}
C {devices/lab_pin.sym} 1140 260 0 0 {name=l17 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 1140 280 0 0 {name=l18 sig_type=std_logic lab=vss}
C {cplz_ls01/AND3LV.sym} 200 480 0 0 {name=XU3}
C {devices/lab_pin.sym} 120 480 0 0 {name=l19 sig_type=std_logic lab=dtu}
C {devices/lab_pin.sym} 120 500 0 0 {name=l20 sig_type=std_logic lab=oe}
C {devices/lab_pin.sym} 120 520 0 0 {name=l21 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 120 540 0 0 {name=l22 sig_type=std_logic lab=eur}
C {devices/lab_pin.sym} 120 560 0 0 {name=l23 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 580 0 0 {name=l24 sig_type=std_logic lab=vss}
C {cplz_ls01/DLY2NS.sym} 540 480 0 0 {name=XU4}
C {devices/lab_pin.sym} 460 480 0 0 {name=l25 sig_type=std_logic lab=eur}
C {devices/lab_pin.sym} 460 500 0 0 {name=l26 sig_type=std_logic lab=eud}
C {devices/lab_pin.sym} 460 520 0 0 {name=l27 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 460 540 0 0 {name=l28 sig_type=std_logic lab=vss}
C {cplz_ls01/AND2LV.sym} 880 480 0 0 {name=XU5}
C {devices/lab_pin.sym} 800 480 0 0 {name=l29 sig_type=std_logic lab=eur}
C {devices/lab_pin.sym} 800 500 0 0 {name=l30 sig_type=std_logic lab=eud}
C {devices/lab_pin.sym} 800 520 0 0 {name=l31 sig_type=std_logic lab=en_up}
C {devices/lab_pin.sym} 800 540 0 0 {name=l32 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 800 560 0 0 {name=l33 sig_type=std_logic lab=vss}
C {cplz_ls01/AND3LV.sym} 1220 480 0 0 {name=XU6}
C {devices/lab_pin.sym} 1140 480 0 0 {name=l34 sig_type=std_logic lab=dtd}
C {devices/lab_pin.sym} 1140 500 0 0 {name=l35 sig_type=std_logic lab=oe}
C {devices/lab_pin.sym} 1140 520 0 0 {name=l36 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 1140 540 0 0 {name=l37 sig_type=std_logic lab=ear}
C {devices/lab_pin.sym} 1140 560 0 0 {name=l38 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 1140 580 0 0 {name=l39 sig_type=std_logic lab=vss}
C {cplz_ls01/DLY2NS.sym} 200 760 0 0 {name=XU7}
C {devices/lab_pin.sym} 120 760 0 0 {name=l40 sig_type=std_logic lab=ear}
C {devices/lab_pin.sym} 120 780 0 0 {name=l41 sig_type=std_logic lab=ead}
C {devices/lab_pin.sym} 120 800 0 0 {name=l42 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 820 0 0 {name=l43 sig_type=std_logic lab=vss}
C {cplz_ls01/AND2LV.sym} 540 760 0 0 {name=XU8}
C {devices/lab_pin.sym} 460 760 0 0 {name=l44 sig_type=std_logic lab=ear}
C {devices/lab_pin.sym} 460 780 0 0 {name=l45 sig_type=std_logic lab=ead}
C {devices/lab_pin.sym} 460 800 0 0 {name=l46 sig_type=std_logic lab=en_a}
C {devices/lab_pin.sym} 460 820 0 0 {name=l47 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 460 840 0 0 {name=l48 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLV.sym} 880 760 0 0 {name=XU9}
C {devices/lab_pin.sym} 800 760 0 0 {name=l49 sig_type=std_logic lab=en_a}
C {devices/lab_pin.sym} 800 780 0 0 {name=l50 sig_type=std_logic lab=en_ab}
C {devices/lab_pin.sym} 800 800 0 0 {name=l51 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 800 820 0 0 {name=l52 sig_type=std_logic lab=vss}
C {cplz_ls01/CTRLLS.sym} 1220 760 0 0 {name=XL1}
C {devices/lab_pin.sym} 1140 760 0 0 {name=l53 sig_type=std_logic lab=en_up}
C {devices/lab_pin.sym} 1140 780 0 0 {name=l54 sig_type=std_logic lab=en_b_h}
C {devices/lab_pin.sym} 1140 800 0 0 {name=l55 sig_type=std_logic lab=enb_b_h}
C {devices/lab_pin.sym} 1140 820 0 0 {name=l56 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 1140 840 0 0 {name=l57 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 1140 860 0 0 {name=l58 sig_type=std_logic lab=vss}
C {cplz_ls01/CTRLLS.sym} 200 1040 0 0 {name=XL2}
C {devices/lab_pin.sym} 120 1040 0 0 {name=l59 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 120 1060 0 0 {name=l60 sig_type=std_logic lab=en_h}
C {devices/lab_pin.sym} 120 1080 0 0 {name=l61 sig_type=std_logic lab=enb_h}
C {devices/lab_pin.sym} 120 1100 0 0 {name=l62 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 1120 0 0 {name=l63 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 120 1140 0 0 {name=l64 sig_type=std_logic lab=vss}
C {cplz_ls01/CTRLLS.sym} 540 1040 0 0 {name=XL3}
C {devices/lab_pin.sym} 460 1040 0 0 {name=l65 sig_type=std_logic lab=tm}
C {devices/lab_pin.sym} 460 1060 0 0 {name=l66 sig_type=std_logic lab=tm_h}
C {devices/lab_pin.sym} 460 1080 0 0 {name=l67 sig_type=std_logic lab=tmb_h}
C {devices/lab_pin.sym} 460 1100 0 0 {name=l68 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 460 1120 0 0 {name=l69 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 460 1140 0 0 {name=l70 sig_type=std_logic lab=vss}
C {cplz_ls01/SCHMLV.sym} 880 1040 0 0 {name=XRX}
C {devices/lab_pin.sym} 800 1040 0 0 {name=l71 sig_type=std_logic lab=a_pad}
C {devices/lab_pin.sym} 800 1060 0 0 {name=l72 sig_type=std_logic lab=arxb}
C {devices/lab_pin.sym} 800 1080 0 0 {name=l73 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 800 1100 0 0 {name=l74 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLV.sym} 1220 1040 0 0 {name=XRB}
C {devices/lab_pin.sym} 1140 1040 0 0 {name=l75 sig_type=std_logic lab=arxb}
C {devices/lab_pin.sym} 1140 1060 0 0 {name=l76 sig_type=std_logic lab=a_rx}
C {devices/lab_pin.sym} 1140 1080 0 0 {name=l77 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 1140 1100 0 0 {name=l78 sig_type=std_logic lab=vss}
C {cplz_ls01/MUXLV.sym} 200 1320 0 0 {name=XM1}
C {devices/lab_pin.sym} 120 1320 0 0 {name=l79 sig_type=std_logic lab=a_rx}
C {devices/lab_pin.sym} 120 1340 0 0 {name=l80 sig_type=std_logic lab=z_l}
C {devices/lab_pin.sym} 120 1360 0 0 {name=l81 sig_type=std_logic lab=tm}
C {devices/lab_pin.sym} 120 1380 0 0 {name=l82 sig_type=std_logic lab=a_in}
C {devices/lab_pin.sym} 120 1400 0 0 {name=l83 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 1420 0 0 {name=l84 sig_type=std_logic lab=vss}
C {cplz_ls01/NANDLV.sym} 540 1320 0 0 {name=XG1}
C {devices/lab_pin.sym} 460 1320 0 0 {name=l85 sig_type=std_logic lab=a_in}
C {devices/lab_pin.sym} 460 1340 0 0 {name=l86 sig_type=std_logic lab=en_up}
C {devices/lab_pin.sym} 460 1360 0 0 {name=l87 sig_type=std_logic lab=a_nb}
C {devices/lab_pin.sym} 460 1380 0 0 {name=l88 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 460 1400 0 0 {name=l89 sig_type=std_logic lab=vss}
C {cplz_ls01/INVLV.sym} 880 1320 0 0 {name=XG2}
C {devices/lab_pin.sym} 800 1320 0 0 {name=l90 sig_type=std_logic lab=a_nb}
C {devices/lab_pin.sym} 800 1340 0 0 {name=l91 sig_type=std_logic lab=a_t}
C {devices/lab_pin.sym} 800 1360 0 0 {name=l92 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 800 1380 0 0 {name=l93 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 1220 1320 0 0 {name=MN1 model=sg13_lv_nmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 1290 0 0 {name=l94 sig_type=std_logic lab=n1}
C {devices/lab_pin.sym} 1200 1320 0 0 {name=l95 sig_type=std_logic lab=a_t}
C {devices/lab_pin.sym} 1240 1350 0 0 {name=l96 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1240 1320 0 0 {name=l97 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 200 1600 0 0 {name=MN2 model=sg13_lv_nmos w=2.0u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 1570 0 0 {name=l98 sig_type=std_logic lab=n2}
C {devices/lab_pin.sym} 180 1600 0 0 {name=l99 sig_type=std_logic lab=a_nb}
C {devices/lab_pin.sym} 220 1630 0 0 {name=l100 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 220 1600 0 0 {name=l101 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 540 1600 0 0 {name=MN3 model=sg13_hv_nmos w=3.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 1570 0 0 {name=l102 sig_type=std_logic lab=x}
C {devices/lab_pin.sym} 520 1600 0 0 {name=l103 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 560 1630 0 0 {name=l104 sig_type=std_logic lab=n1}
C {devices/lab_pin.sym} 560 1600 0 0 {name=l105 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 880 1600 0 0 {name=MN4 model=sg13_hv_nmos w=3.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 1570 0 0 {name=l106 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 860 1600 0 0 {name=l107 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 900 1630 0 0 {name=l108 sig_type=std_logic lab=n2}
C {devices/lab_pin.sym} 900 1600 0 0 {name=l109 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 1220 1600 0 0 {name=MP1 model=sg13_hv_pmos w=0.8u l=0.8u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 1570 0 0 {name=l110 sig_type=std_logic lab=x}
C {devices/lab_pin.sym} 1200 1600 0 0 {name=l111 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 1240 1630 0 0 {name=l112 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 1240 1600 0 0 {name=l113 sig_type=std_logic lab=vddh}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 200 1880 0 0 {name=MP2 model=sg13_hv_pmos w=0.8u l=0.8u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 1850 0 0 {name=l114 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 180 1880 0 0 {name=l115 sig_type=std_logic lab=x}
C {devices/lab_pin.sym} 220 1910 0 0 {name=l116 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 220 1880 0 0 {name=l117 sig_type=std_logic lab=vddh}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 540 1880 0 0 {name=MN5 model=sg13_hv_nmos w=0.5u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 1850 0 0 {name=l118 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 520 1880 0 0 {name=l119 sig_type=std_logic lab=enb_h}
C {devices/lab_pin.sym} 560 1910 0 0 {name=l120 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 560 1880 0 0 {name=l121 sig_type=std_logic lab=vss}
C {cplz_ls01/INVHV1S.sym} 880 1880 0 0 {name=XH1}
C {devices/lab_pin.sym} 800 1880 0 0 {name=l122 sig_type=std_logic lab=y}
C {devices/lab_pin.sym} 800 1900 0 0 {name=l123 sig_type=std_logic lab=z1}
C {devices/lab_pin.sym} 800 1920 0 0 {name=l124 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 800 1940 0 0 {name=l125 sig_type=std_logic lab=vss}
C {cplz_ls01/INVHV2T.sym} 1220 1880 0 0 {name=XH2}
C {devices/lab_pin.sym} 1140 1880 0 0 {name=l126 sig_type=std_logic lab=z1}
C {devices/lab_pin.sym} 1140 1900 0 0 {name=l127 sig_type=std_logic lab=z_h}
C {devices/lab_pin.sym} 1140 1920 0 0 {name=l128 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 1140 1940 0 0 {name=l129 sig_type=std_logic lab=vss}
C {cplz_ls01/NANDHV.sym} 200 2160 0 0 {name=XD1}
C {devices/lab_pin.sym} 120 2160 0 0 {name=l130 sig_type=std_logic lab=z_h}
C {devices/lab_pin.sym} 120 2180 0 0 {name=l131 sig_type=std_logic lab=en_b_h}
C {devices/lab_pin.sym} 120 2200 0 0 {name=l132 sig_type=std_logic lab=pg}
C {devices/lab_pin.sym} 120 2220 0 0 {name=l133 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 120 2240 0 0 {name=l134 sig_type=std_logic lab=vss}
C {cplz_ls01/NORHV.sym} 540 2160 0 0 {name=XD2}
C {devices/lab_pin.sym} 460 2160 0 0 {name=l135 sig_type=std_logic lab=z_h}
C {devices/lab_pin.sym} 460 2180 0 0 {name=l136 sig_type=std_logic lab=enb_b_h}
C {devices/lab_pin.sym} 460 2200 0 0 {name=l137 sig_type=std_logic lab=ng}
C {devices/lab_pin.sym} 460 2220 0 0 {name=l138 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 460 2240 0 0 {name=l139 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 880 2160 0 0 {name=MPD model=sg13_hv_pmos w=12u l=0.45u ng=1 m=8 spiceprefix=X}
C {devices/lab_pin.sym} 900 2130 0 0 {name=l140 sig_type=std_logic lab=b_pad}
C {devices/lab_pin.sym} 860 2160 0 0 {name=l141 sig_type=std_logic lab=pg}
C {devices/lab_pin.sym} 900 2190 0 0 {name=l142 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 900 2160 0 0 {name=l143 sig_type=std_logic lab=vddh}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 1220 2160 0 0 {name=MND model=sg13_hv_nmos w=12u l=0.45u ng=1 m=4 spiceprefix=X}
C {devices/lab_pin.sym} 1240 2130 0 0 {name=l144 sig_type=std_logic lab=b_pad}
C {devices/lab_pin.sym} 1200 2160 0 0 {name=l145 sig_type=std_logic lab=ng}
C {devices/lab_pin.sym} 1240 2190 0 0 {name=l146 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1240 2160 0 0 {name=l147 sig_type=std_logic lab=vss}
C {devices/res.sym} 200 2440 0 0 {name=RSER value=200 footprint=1206 m=1}
C {devices/lab_pin.sym} 200 2410 0 0 {name=l148 sig_type=std_logic lab=b_pad}
C {devices/lab_pin.sym} 200 2470 0 0 {name=l149 sig_type=std_logic lab=b_rx}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 540 2440 0 0 {name=MP6 model=sg13_hv_pmos w=1.5u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 2410 0 0 {name=l150 sig_type=std_logic lab=d1}
C {devices/lab_pin.sym} 520 2440 0 0 {name=l151 sig_type=std_logic lab=b_rx}
C {devices/lab_pin.sym} 560 2470 0 0 {name=l152 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 560 2440 0 0 {name=l153 sig_type=std_logic lab=vddh}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 880 2440 0 0 {name=MN7 model=sg13_hv_nmos w=1.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 2410 0 0 {name=l154 sig_type=std_logic lab=d1}
C {devices/lab_pin.sym} 860 2440 0 0 {name=l155 sig_type=std_logic lab=b_rx}
C {devices/lab_pin.sym} 900 2470 0 0 {name=l156 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 900 2440 0 0 {name=l157 sig_type=std_logic lab=vss}
C {cplz_ls01/MUXHV.sym} 1220 2440 0 0 {name=XM2}
C {devices/lab_pin.sym} 1140 2440 0 0 {name=l158 sig_type=std_logic lab=d1}
C {devices/lab_pin.sym} 1140 2460 0 0 {name=l159 sig_type=std_logic lab=z_h}
C {devices/lab_pin.sym} 1140 2480 0 0 {name=l160 sig_type=std_logic lab=tm_h}
C {devices/lab_pin.sym} 1140 2500 0 0 {name=l161 sig_type=std_logic lab=tmb_h}
C {devices/lab_pin.sym} 1140 2520 0 0 {name=l162 sig_type=std_logic lab=d1m}
C {devices/lab_pin.sym} 1140 2540 0 0 {name=l163 sig_type=std_logic lab=vddh}
C {devices/lab_pin.sym} 1140 2560 0 0 {name=l164 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_hv_pmos.sym} 200 2720 0 0 {name=MP8 model=sg13_hv_pmos w=1.0u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 220 2690 0 0 {name=l165 sig_type=std_logic lab=d2}
C {devices/lab_pin.sym} 180 2720 0 0 {name=l166 sig_type=std_logic lab=d1m}
C {devices/lab_pin.sym} 220 2750 0 0 {name=l167 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 220 2720 0 0 {name=l168 sig_type=std_logic lab=vddl}
C {sg13cmos5l_pr/sg13_hv_nmos.sym} 540 2720 0 0 {name=MN9 model=sg13_hv_nmos w=0.8u l=0.45u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 560 2690 0 0 {name=l169 sig_type=std_logic lab=d2}
C {devices/lab_pin.sym} 520 2720 0 0 {name=l170 sig_type=std_logic lab=d1m}
C {devices/lab_pin.sym} 560 2750 0 0 {name=l171 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 560 2720 0 0 {name=l172 sig_type=std_logic lab=vss}
C {cplz_ls01/SCHMLV.sym} 880 2720 0 0 {name=XS2}
C {devices/lab_pin.sym} 800 2720 0 0 {name=l173 sig_type=std_logic lab=d2}
C {devices/lab_pin.sym} 800 2740 0 0 {name=l174 sig_type=std_logic lab=d3}
C {devices/lab_pin.sym} 800 2760 0 0 {name=l175 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 800 2780 0 0 {name=l176 sig_type=std_logic lab=vss}
C {cplz_ls01/NANDLV.sym} 1220 2720 0 0 {name=XPK}
C {devices/lab_pin.sym} 1140 2720 0 0 {name=l177 sig_type=std_logic lab=d3}
C {devices/lab_pin.sym} 1140 2740 0 0 {name=l178 sig_type=std_logic lab=en_a}
C {devices/lab_pin.sym} 1140 2760 0 0 {name=l179 sig_type=std_logic lab=z_l}
C {devices/lab_pin.sym} 1140 2780 0 0 {name=l180 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 1140 2800 0 0 {name=l181 sig_type=std_logic lab=vss}
C {cplz_ls01/NANDLV.sym} 200 3000 0 0 {name=XA1}
C {devices/lab_pin.sym} 120 3000 0 0 {name=l182 sig_type=std_logic lab=z_l}
C {devices/lab_pin.sym} 120 3020 0 0 {name=l183 sig_type=std_logic lab=en_a}
C {devices/lab_pin.sym} 120 3040 0 0 {name=l184 sig_type=std_logic lab=apg}
C {devices/lab_pin.sym} 120 3060 0 0 {name=l185 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 3080 0 0 {name=l186 sig_type=std_logic lab=vss}
C {cplz_ls01/NORLV.sym} 540 3000 0 0 {name=XA2}
C {devices/lab_pin.sym} 460 3000 0 0 {name=l187 sig_type=std_logic lab=z_l}
C {devices/lab_pin.sym} 460 3020 0 0 {name=l188 sig_type=std_logic lab=en_ab}
C {devices/lab_pin.sym} 460 3040 0 0 {name=l189 sig_type=std_logic lab=ang}
C {devices/lab_pin.sym} 460 3060 0 0 {name=l190 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 460 3080 0 0 {name=l191 sig_type=std_logic lab=vss}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 880 3000 0 0 {name=MPA model=sg13_lv_pmos w=24u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 900 2970 0 0 {name=l192 sig_type=std_logic lab=a_pad}
C {devices/lab_pin.sym} 860 3000 0 0 {name=l193 sig_type=std_logic lab=apg}
C {devices/lab_pin.sym} 900 3030 0 0 {name=l194 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 900 3000 0 0 {name=l195 sig_type=std_logic lab=vddl}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 1220 3000 0 0 {name=MNA model=sg13_lv_nmos w=12u l=0.13u ng=1 m=1 spiceprefix=X}
C {devices/lab_pin.sym} 1240 2970 0 0 {name=l196 sig_type=std_logic lab=a_pad}
C {devices/lab_pin.sym} 1200 3000 0 0 {name=l197 sig_type=std_logic lab=ang}
C {devices/lab_pin.sym} 1240 3030 0 0 {name=l198 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1240 3000 0 0 {name=l199 sig_type=std_logic lab=vss}
C {cplz_ls01/DIV16.sym} 200 3280 0 0 {name=XDV}
C {devices/lab_pin.sym} 120 3280 0 0 {name=l200 sig_type=std_logic lab=z_l}
C {devices/lab_pin.sym} 120 3300 0 0 {name=l201 sig_type=std_logic lab=ring_div}
C {devices/lab_pin.sym} 120 3320 0 0 {name=l202 sig_type=std_logic lab=vddl}
C {devices/lab_pin.sym} 120 3340 0 0 {name=l203 sig_type=std_logic lab=vss}
