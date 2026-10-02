v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {schematics/bidir_channel.sym} 0 0 0 0 {name=XCH0}
C {devices/lab_pin.sym} -140 -40 0 0 {name=l1 sig_type=std_logic lab=analog_0}
C {devices/lab_pin.sym} 140 -10 0 1 {name=l2 sig_type=std_logic lab=analog_1}
C {devices/lab_pin.sym} -140 -20 0 0 {name=l3 sig_type=std_logic lab=ui_in[0]}
C {devices/lab_pin.sym} -140 0 0 0 {name=l4 sig_type=std_logic lab=ui_in[4]}
C {devices/lab_pin.sym} -140 20 0 0 {name=l5 sig_type=std_logic lab=ui_in[5]}
C {devices/lab_pin.sym} -140 40 0 0 {name=l6 sig_type=std_logic lab=ui_in[6]}
C {devices/lab_pin.sym} 140 10 0 1 {name=l7 sig_type=std_logic lab=uo_out[0]}
C {devices/lab_pin.sym} -20 -80 0 0 {name=l8 sig_type=std_logic lab=VPWR}
C {devices/lab_pin.sym} 20 -80 0 1 {name=l9 sig_type=std_logic lab=VAPWR}
C {devices/lab_pin.sym} 0 80 0 0 {name=l10 sig_type=std_logic lab=VGND}
C {schematics/bidir_channel.sym} 500 0 0 0 {name=XCH1}
C {devices/lab_pin.sym} 360 -40 0 0 {name=l11 sig_type=std_logic lab=a1}
C {devices/lab_pin.sym} 640 -10 0 1 {name=l12 sig_type=std_logic lab=b1}
C {devices/lab_pin.sym} 360 -20 0 0 {name=l13 sig_type=std_logic lab=ui_in[1]}
C {devices/lab_pin.sym} 360 0 0 0 {name=l14 sig_type=std_logic lab=ui_in[4]}
C {devices/lab_pin.sym} 360 20 0 0 {name=l15 sig_type=std_logic lab=ui_in[5]}
C {devices/lab_pin.sym} 360 40 0 0 {name=l16 sig_type=std_logic lab=ui_in[6]}
C {devices/lab_pin.sym} 640 10 0 1 {name=l17 sig_type=std_logic lab=uo_out[1]}
C {devices/lab_pin.sym} 480 -80 0 0 {name=l18 sig_type=std_logic lab=VPWR}
C {devices/lab_pin.sym} 520 -80 0 1 {name=l19 sig_type=std_logic lab=VAPWR}
C {devices/lab_pin.sym} 500 80 0 0 {name=l20 sig_type=std_logic lab=VGND}
C {schematics/bidir_channel.sym} 1000 0 0 0 {name=XCH2}
C {devices/lab_pin.sym} 860 -40 0 0 {name=l21 sig_type=std_logic lab=a2}
C {devices/lab_pin.sym} 1140 -10 0 1 {name=l22 sig_type=std_logic lab=b2}
C {devices/lab_pin.sym} 860 -20 0 0 {name=l23 sig_type=std_logic lab=ui_in[2]}
C {devices/lab_pin.sym} 860 0 0 0 {name=l24 sig_type=std_logic lab=ui_in[4]}
C {devices/lab_pin.sym} 860 20 0 0 {name=l25 sig_type=std_logic lab=ui_in[5]}
C {devices/lab_pin.sym} 860 40 0 0 {name=l26 sig_type=std_logic lab=ui_in[6]}
C {devices/lab_pin.sym} 1140 10 0 1 {name=l27 sig_type=std_logic lab=uo_out[2]}
C {devices/lab_pin.sym} 980 -80 0 0 {name=l28 sig_type=std_logic lab=VPWR}
C {devices/lab_pin.sym} 1020 -80 0 1 {name=l29 sig_type=std_logic lab=VAPWR}
C {devices/lab_pin.sym} 1000 80 0 0 {name=l30 sig_type=std_logic lab=VGND}
C {schematics/bidir_channel.sym} 1500 0 0 0 {name=XCH3}
C {devices/lab_pin.sym} 1360 -40 0 0 {name=l31 sig_type=std_logic lab=a3}
C {devices/lab_pin.sym} 1640 -10 0 1 {name=l32 sig_type=std_logic lab=b3}
C {devices/lab_pin.sym} 1360 -20 0 0 {name=l33 sig_type=std_logic lab=ui_in[3]}
C {devices/lab_pin.sym} 1360 0 0 0 {name=l34 sig_type=std_logic lab=ui_in[4]}
C {devices/lab_pin.sym} 1360 20 0 0 {name=l35 sig_type=std_logic lab=ui_in[5]}
C {devices/lab_pin.sym} 1360 40 0 0 {name=l36 sig_type=std_logic lab=ui_in[6]}
C {devices/lab_pin.sym} 1640 10 0 1 {name=l37 sig_type=std_logic lab=uo_out[3]}
C {devices/lab_pin.sym} 1480 -80 0 0 {name=l38 sig_type=std_logic lab=VPWR}
C {devices/lab_pin.sym} 1520 -80 0 1 {name=l39 sig_type=std_logic lab=VAPWR}
C {devices/lab_pin.sym} 1500 80 0 0 {name=l40 sig_type=std_logic lab=VGND}
C {devices/iopin.sym} -400 -600 0 1 {name=p0 lab=VPWR}
C {devices/iopin.sym} -400 -580 0 1 {name=p1 lab=VAPWR}
C {devices/iopin.sym} -400 -560 0 1 {name=p2 lab=VGND}
C {devices/iopin.sym} -400 -540 0 1 {name=p3 lab=rst_n}
C {devices/iopin.sym} -400 -520 0 1 {name=p4 lab=clk}
C {devices/iopin.sym} -400 -500 0 1 {name=p5 lab=ena}
C {devices/iopin.sym} -400 -480 0 1 {name=p6 lab=uio_in[7]}
C {devices/iopin.sym} -400 -460 0 1 {name=p7 lab=uio_in[6]}
C {devices/iopin.sym} -400 -440 0 1 {name=p8 lab=uio_in[5]}
C {devices/iopin.sym} -400 -420 0 1 {name=p9 lab=uio_in[4]}
C {devices/iopin.sym} -400 -400 0 1 {name=p10 lab=uio_in[3]}
C {devices/iopin.sym} -400 -380 0 1 {name=p11 lab=uio_in[2]}
C {devices/iopin.sym} -400 -360 0 1 {name=p12 lab=uio_in[1]}
C {devices/iopin.sym} -400 -340 0 1 {name=p13 lab=uio_in[0]}
C {devices/iopin.sym} -400 -320 0 1 {name=p14 lab=ui_in[7]}
C {devices/iopin.sym} -400 -300 0 1 {name=p15 lab=ui_in[6]}
C {devices/iopin.sym} -400 -280 0 1 {name=p16 lab=ui_in[5]}
C {devices/iopin.sym} -400 -260 0 1 {name=p17 lab=ui_in[4]}
C {devices/iopin.sym} -400 -240 0 1 {name=p18 lab=ui_in[3]}
C {devices/iopin.sym} -400 -220 0 1 {name=p19 lab=ui_in[2]}
C {devices/iopin.sym} -400 -200 0 1 {name=p20 lab=ui_in[1]}
C {devices/iopin.sym} -400 -180 0 1 {name=p21 lab=ui_in[0]}
C {devices/iopin.sym} -400 -160 0 1 {name=p22 lab=uio_oe[7]}
C {devices/iopin.sym} -400 -140 0 1 {name=p23 lab=uio_oe[6]}
C {devices/iopin.sym} -400 -120 0 1 {name=p24 lab=uio_oe[5]}
C {devices/iopin.sym} -400 -100 0 1 {name=p25 lab=uio_oe[4]}
C {devices/iopin.sym} -400 -80 0 1 {name=p26 lab=uio_oe[3]}
C {devices/iopin.sym} -400 -60 0 1 {name=p27 lab=uio_oe[2]}
C {devices/iopin.sym} -400 -40 0 1 {name=p28 lab=uio_oe[1]}
C {devices/iopin.sym} -400 -20 0 1 {name=p29 lab=uio_oe[0]}
C {devices/iopin.sym} -400 0 0 1 {name=p30 lab=uio_out[7]}
C {devices/iopin.sym} -400 20 0 1 {name=p31 lab=uio_out[6]}
C {devices/iopin.sym} -400 40 0 1 {name=p32 lab=uio_out[5]}
C {devices/iopin.sym} -400 60 0 1 {name=p33 lab=uio_out[4]}
C {devices/iopin.sym} -400 80 0 1 {name=p34 lab=uio_out[3]}
C {devices/iopin.sym} -400 100 0 1 {name=p35 lab=uio_out[2]}
C {devices/iopin.sym} -400 120 0 1 {name=p36 lab=uio_out[1]}
C {devices/iopin.sym} -400 140 0 1 {name=p37 lab=uio_out[0]}
C {devices/iopin.sym} -400 160 0 1 {name=p38 lab=uo_out[7]}
C {devices/iopin.sym} -400 180 0 1 {name=p39 lab=uo_out[6]}
C {devices/iopin.sym} -400 200 0 1 {name=p40 lab=uo_out[5]}
C {devices/iopin.sym} -400 220 0 1 {name=p41 lab=uo_out[4]}
C {devices/iopin.sym} -400 240 0 1 {name=p42 lab=uo_out[3]}
C {devices/iopin.sym} -400 260 0 1 {name=p43 lab=uo_out[2]}
C {devices/iopin.sym} -400 280 0 1 {name=p44 lab=uo_out[1]}
C {devices/iopin.sym} -400 300 0 1 {name=p45 lab=uo_out[0]}
C {devices/iopin.sym} -400 320 0 1 {name=p46 lab=analog_2}
C {devices/iopin.sym} -400 340 0 1 {name=p47 lab=analog_1}
C {devices/iopin.sym} -400 360 0 1 {name=p48 lab=analog_0}
