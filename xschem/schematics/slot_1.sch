v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/bidir_channel.sym} 0 0 0 0 {name=XCH0}
C {devices/lab_pin.sym} -140 -40 0 0 {name=l1 sig_type=std_logic lab=s1_an[0]}
C {devices/lab_pin.sym} -140 -20 0 0 {name=l2 sig_type=std_logic lab=dig_in[0]}
C {devices/lab_pin.sym} -140 0 0 0 {name=l3 sig_type=std_logic lab=dig_in[8]}
C {devices/lab_pin.sym} -140 20 0 0 {name=l4 sig_type=std_logic lab=enable}
C {devices/lab_pin.sym} -140 40 0 0 {name=l5 sig_type=std_logic lab=dig_in[4]}
C {devices/lab_pin.sym} 140 -10 0 1 {name=l6 sig_type=std_logic lab=s1_an[1]}
C {devices/lab_pin.sym} 140 10 0 1 {name=l7 sig_type=std_logic lab=dig_out[0]}
C {devices/lab_pin.sym} -20 -80 0 0 {name=l8 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 20 -80 0 1 {name=l9 sig_type=std_logic lab=vdd_3v3}
C {devices/lab_pin.sym} 0 80 0 0 {name=l10 sig_type=std_logic lab=vss_1v2}
C {schematics/divider_16.sym} 0 300 0 0 {name=XDV0}
C {devices/lab_pin.sym} -90 300 0 0 {name=l11 sig_type=std_logic lab=dig_out[0]}
C {devices/lab_pin.sym} 90 300 0 1 {name=l12 sig_type=std_logic lab=dig_out[4]}
C {devices/lab_pin.sym} 0 250 0 0 {name=l13 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 0 350 0 0 {name=l14 sig_type=std_logic lab=vss_1v2}
C {schematics/bidir_channel.sym} 700 0 0 0 {name=XCH1}
C {devices/lab_pin.sym} 560 -40 0 0 {name=l15 sig_type=std_logic lab=a1}
C {devices/lab_pin.sym} 560 -20 0 0 {name=l16 sig_type=std_logic lab=dig_in[1]}
C {devices/lab_pin.sym} 560 0 0 0 {name=l17 sig_type=std_logic lab=dig_in[8]}
C {devices/lab_pin.sym} 560 20 0 0 {name=l18 sig_type=std_logic lab=enable}
C {devices/lab_pin.sym} 560 40 0 0 {name=l19 sig_type=std_logic lab=dig_in[5]}
C {devices/lab_pin.sym} 840 -10 0 1 {name=l20 sig_type=std_logic lab=b_bus}
C {devices/lab_pin.sym} 840 10 0 1 {name=l21 sig_type=std_logic lab=dig_out[1]}
C {devices/lab_pin.sym} 680 -80 0 0 {name=l22 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 720 -80 0 1 {name=l23 sig_type=std_logic lab=vdd_3v3}
C {devices/lab_pin.sym} 700 80 0 0 {name=l24 sig_type=std_logic lab=vss_1v2}
C {schematics/divider_16.sym} 700 300 0 0 {name=XDV1}
C {devices/lab_pin.sym} 610 300 0 0 {name=l25 sig_type=std_logic lab=dig_out[1]}
C {devices/lab_pin.sym} 790 300 0 1 {name=l26 sig_type=std_logic lab=dig_out[5]}
C {devices/lab_pin.sym} 700 250 0 0 {name=l27 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 700 350 0 0 {name=l28 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_or2_1.sym} 400 600 0 0 {name=XTE1}
C {devices/lab_pin.sym} 330 590 0 0 {name=l29 sig_type=std_logic lab=dig_in[1]}
C {devices/lab_pin.sym} 330 610 0 0 {name=l30 sig_type=std_logic lab=dig_in[5]}
C {devices/lab_pin.sym} 470 600 0 1 {name=l31 sig_type=std_logic lab=teb1}
C {devices/lab_pin.sym} 400 550 0 0 {name=l32 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 400 650 0 0 {name=l33 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_ebufn_2.sym} 700 600 0 0 {name=XDR1}
C {devices/lab_pin.sym} 630 590 0 0 {name=l34 sig_type=std_logic lab=dig_in[9]}
C {devices/lab_pin.sym} 630 610 0 0 {name=l35 sig_type=std_logic lab=teb1}
C {devices/lab_pin.sym} 770 600 0 1 {name=l36 sig_type=std_logic lab=a1}
C {devices/lab_pin.sym} 700 550 0 0 {name=l37 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 700 650 0 0 {name=l38 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_buf_1.sym} 1000 600 0 0 {name=XRB1}
C {devices/lab_pin.sym} 930 600 0 0 {name=l39 sig_type=std_logic lab=a1}
C {devices/lab_pin.sym} 1070 600 0 1 {name=l40 sig_type=std_logic lab=dig_out[8]}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l41 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1000 650 0 0 {name=l42 sig_type=std_logic lab=vss_1v2}
C {schematics/bidir_channel.sym} 1400 0 0 0 {name=XCH2}
C {devices/lab_pin.sym} 1260 -40 0 0 {name=l43 sig_type=std_logic lab=a2}
C {devices/lab_pin.sym} 1260 -20 0 0 {name=l44 sig_type=std_logic lab=dig_in[2]}
C {devices/lab_pin.sym} 1260 0 0 0 {name=l45 sig_type=std_logic lab=dig_in[8]}
C {devices/lab_pin.sym} 1260 20 0 0 {name=l46 sig_type=std_logic lab=enable}
C {devices/lab_pin.sym} 1260 40 0 0 {name=l47 sig_type=std_logic lab=dig_in[6]}
C {devices/lab_pin.sym} 1540 -10 0 1 {name=l48 sig_type=std_logic lab=b_bus}
C {devices/lab_pin.sym} 1540 10 0 1 {name=l49 sig_type=std_logic lab=dig_out[2]}
C {devices/lab_pin.sym} 1380 -80 0 0 {name=l50 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1420 -80 0 1 {name=l51 sig_type=std_logic lab=vdd_3v3}
C {devices/lab_pin.sym} 1400 80 0 0 {name=l52 sig_type=std_logic lab=vss_1v2}
C {schematics/divider_16.sym} 1400 300 0 0 {name=XDV2}
C {devices/lab_pin.sym} 1310 300 0 0 {name=l53 sig_type=std_logic lab=dig_out[2]}
C {devices/lab_pin.sym} 1490 300 0 1 {name=l54 sig_type=std_logic lab=dig_out[6]}
C {devices/lab_pin.sym} 1400 250 0 0 {name=l55 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1400 350 0 0 {name=l56 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_or2_1.sym} 1100 600 0 0 {name=XTE2}
C {devices/lab_pin.sym} 1030 590 0 0 {name=l57 sig_type=std_logic lab=dig_in[2]}
C {devices/lab_pin.sym} 1030 610 0 0 {name=l58 sig_type=std_logic lab=dig_in[6]}
C {devices/lab_pin.sym} 1170 600 0 1 {name=l59 sig_type=std_logic lab=teb2}
C {devices/lab_pin.sym} 1100 550 0 0 {name=l60 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1100 650 0 0 {name=l61 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_ebufn_2.sym} 1400 600 0 0 {name=XDR2}
C {devices/lab_pin.sym} 1330 590 0 0 {name=l62 sig_type=std_logic lab=dig_in[10]}
C {devices/lab_pin.sym} 1330 610 0 0 {name=l63 sig_type=std_logic lab=teb2}
C {devices/lab_pin.sym} 1470 600 0 1 {name=l64 sig_type=std_logic lab=a2}
C {devices/lab_pin.sym} 1400 550 0 0 {name=l65 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1400 650 0 0 {name=l66 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_buf_1.sym} 1700 600 0 0 {name=XRB2}
C {devices/lab_pin.sym} 1630 600 0 0 {name=l67 sig_type=std_logic lab=a2}
C {devices/lab_pin.sym} 1770 600 0 1 {name=l68 sig_type=std_logic lab=dig_out[9]}
C {devices/lab_pin.sym} 1700 550 0 0 {name=l69 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1700 650 0 0 {name=l70 sig_type=std_logic lab=vss_1v2}
C {schematics/bidir_channel.sym} 2100 0 0 0 {name=XCH3}
C {devices/lab_pin.sym} 1960 -40 0 0 {name=l71 sig_type=std_logic lab=a3}
C {devices/lab_pin.sym} 1960 -20 0 0 {name=l72 sig_type=std_logic lab=dig_in[3]}
C {devices/lab_pin.sym} 1960 0 0 0 {name=l73 sig_type=std_logic lab=dig_in[8]}
C {devices/lab_pin.sym} 1960 20 0 0 {name=l74 sig_type=std_logic lab=enable}
C {devices/lab_pin.sym} 1960 40 0 0 {name=l75 sig_type=std_logic lab=dig_in[7]}
C {devices/lab_pin.sym} 2240 -10 0 1 {name=l76 sig_type=std_logic lab=b_bus}
C {devices/lab_pin.sym} 2240 10 0 1 {name=l77 sig_type=std_logic lab=dig_out[3]}
C {devices/lab_pin.sym} 2080 -80 0 0 {name=l78 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 2120 -80 0 1 {name=l79 sig_type=std_logic lab=vdd_3v3}
C {devices/lab_pin.sym} 2100 80 0 0 {name=l80 sig_type=std_logic lab=vss_1v2}
C {schematics/divider_16.sym} 2100 300 0 0 {name=XDV3}
C {devices/lab_pin.sym} 2010 300 0 0 {name=l81 sig_type=std_logic lab=dig_out[3]}
C {devices/lab_pin.sym} 2190 300 0 1 {name=l82 sig_type=std_logic lab=dig_out[7]}
C {devices/lab_pin.sym} 2100 250 0 0 {name=l83 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 2100 350 0 0 {name=l84 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_or2_1.sym} 1800 600 0 0 {name=XTE3}
C {devices/lab_pin.sym} 1730 590 0 0 {name=l85 sig_type=std_logic lab=dig_in[3]}
C {devices/lab_pin.sym} 1730 610 0 0 {name=l86 sig_type=std_logic lab=dig_in[7]}
C {devices/lab_pin.sym} 1870 600 0 1 {name=l87 sig_type=std_logic lab=teb3}
C {devices/lab_pin.sym} 1800 550 0 0 {name=l88 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 1800 650 0 0 {name=l89 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_ebufn_2.sym} 2100 600 0 0 {name=XDR3}
C {devices/lab_pin.sym} 2030 590 0 0 {name=l90 sig_type=std_logic lab=dig_in[11]}
C {devices/lab_pin.sym} 2030 610 0 0 {name=l91 sig_type=std_logic lab=teb3}
C {devices/lab_pin.sym} 2170 600 0 1 {name=l92 sig_type=std_logic lab=a3}
C {devices/lab_pin.sym} 2100 550 0 0 {name=l93 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 2100 650 0 0 {name=l94 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_buf_1.sym} 2400 600 0 0 {name=XRB3}
C {devices/lab_pin.sym} 2330 600 0 0 {name=l95 sig_type=std_logic lab=a3}
C {devices/lab_pin.sym} 2470 600 0 1 {name=l96 sig_type=std_logic lab=dig_out[10]}
C {devices/lab_pin.sym} 2400 550 0 0 {name=l97 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 2400 650 0 0 {name=l98 sig_type=std_logic lab=vss_1v2}
C {logic_gates/sg13cmos5l_buf_1.sym} 0 900 0 0 {name=XEN}
C {devices/lab_pin.sym} -70 900 0 0 {name=l99 sig_type=std_logic lab=enable}
C {devices/lab_pin.sym} 70 900 0 1 {name=l100 sig_type=std_logic lab=dig_out[11]}
C {devices/lab_pin.sym} 0 850 0 0 {name=l101 sig_type=std_logic lab=vdd_1v2}
C {devices/lab_pin.sym} 0 950 0 0 {name=l102 sig_type=std_logic lab=vss_1v2}
T {slot_1: four channels in the Chipalooza slot 1 wrapper. See layout/README.md for the pin map.} -800 -400 0 0 0.6 0.6 {}
C {devices/iopin.sym} -900 -300 0 1 {name=p0 lab=vdd_1v2}
C {devices/iopin.sym} -900 -280 0 1 {name=p1 lab=vdd_3v3}
C {devices/iopin.sym} -900 -260 0 1 {name=p2 lab=vss_1v2}
C {devices/iopin.sym} -900 -240 0 1 {name=p3 lab=vss_3v3}
C {devices/iopin.sym} -900 -220 0 1 {name=p4 lab=enable}
C {devices/iopin.sym} -900 -200 0 1 {name=p5 lab=clk}
C {devices/iopin.sym} -900 -180 0 1 {name=p6 lab=reset}
C {devices/iopin.sym} -900 -160 0 1 {name=p7 lab=s1_an[0]}
C {devices/iopin.sym} -900 -140 0 1 {name=p8 lab=s1_an[1]}
C {devices/iopin.sym} -900 -120 0 1 {name=p9 lab=s1_an_0_esd}
C {devices/iopin.sym} -900 -100 0 1 {name=p10 lab=vbias}
C {devices/iopin.sym} -900 -80 0 1 {name=p11 lab=ibias0}
C {devices/iopin.sym} -900 -60 0 1 {name=p12 lab=ibias1}
C {devices/iopin.sym} -900 -40 0 1 {name=p13 lab=analog_bus0}
C {devices/iopin.sym} -900 -20 0 1 {name=p14 lab=analog_bus1}
C {devices/iopin.sym} -900 0 0 1 {name=p15 lab=analog_bus2}
C {devices/iopin.sym} -900 20 0 1 {name=p16 lab=analog_bus3}
C {devices/iopin.sym} -900 40 0 1 {name=p17 lab=dig_in[0]}
C {devices/iopin.sym} -900 60 0 1 {name=p18 lab=dig_in[1]}
C {devices/iopin.sym} -900 80 0 1 {name=p19 lab=dig_in[2]}
C {devices/iopin.sym} -900 100 0 1 {name=p20 lab=dig_in[3]}
C {devices/iopin.sym} -900 120 0 1 {name=p21 lab=dig_in[4]}
C {devices/iopin.sym} -900 140 0 1 {name=p22 lab=dig_in[5]}
C {devices/iopin.sym} -900 160 0 1 {name=p23 lab=dig_in[6]}
C {devices/iopin.sym} -900 180 0 1 {name=p24 lab=dig_in[7]}
C {devices/iopin.sym} -900 200 0 1 {name=p25 lab=dig_in[8]}
C {devices/iopin.sym} -900 220 0 1 {name=p26 lab=dig_in[9]}
C {devices/iopin.sym} -900 240 0 1 {name=p27 lab=dig_in[10]}
C {devices/iopin.sym} -900 260 0 1 {name=p28 lab=dig_in[11]}
C {devices/iopin.sym} -900 280 0 1 {name=p29 lab=dig_in[12]}
C {devices/iopin.sym} -900 300 0 1 {name=p30 lab=dig_in[13]}
C {devices/iopin.sym} -900 320 0 1 {name=p31 lab=dig_in[14]}
C {devices/iopin.sym} -900 340 0 1 {name=p32 lab=dig_in[15]}
C {devices/iopin.sym} -900 360 0 1 {name=p33 lab=dig_in[16]}
C {devices/iopin.sym} -900 380 0 1 {name=p34 lab=dig_in[17]}
C {devices/iopin.sym} -900 400 0 1 {name=p35 lab=dig_in[18]}
C {devices/iopin.sym} -900 420 0 1 {name=p36 lab=dig_in[19]}
C {devices/iopin.sym} -900 440 0 1 {name=p37 lab=dig_in[20]}
C {devices/iopin.sym} -900 460 0 1 {name=p38 lab=dig_in[21]}
C {devices/iopin.sym} -900 480 0 1 {name=p39 lab=dig_in[22]}
C {devices/iopin.sym} -900 500 0 1 {name=p40 lab=dig_in[23]}
C {devices/iopin.sym} -900 520 0 1 {name=p41 lab=dig_out[0]}
C {devices/iopin.sym} -900 540 0 1 {name=p42 lab=dig_out[1]}
C {devices/iopin.sym} -900 560 0 1 {name=p43 lab=dig_out[2]}
C {devices/iopin.sym} -900 580 0 1 {name=p44 lab=dig_out[3]}
C {devices/iopin.sym} -900 600 0 1 {name=p45 lab=dig_out[4]}
C {devices/iopin.sym} -900 620 0 1 {name=p46 lab=dig_out[5]}
C {devices/iopin.sym} -900 640 0 1 {name=p47 lab=dig_out[6]}
C {devices/iopin.sym} -900 660 0 1 {name=p48 lab=dig_out[7]}
C {devices/iopin.sym} -900 680 0 1 {name=p49 lab=dig_out[8]}
C {devices/iopin.sym} -900 700 0 1 {name=p50 lab=dig_out[9]}
C {devices/iopin.sym} -900 720 0 1 {name=p51 lab=dig_out[10]}
C {devices/iopin.sym} -900 740 0 1 {name=p52 lab=dig_out[11]}
