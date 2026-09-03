* TB3 -- CPLZ-LS01 exhaustive control truth table (dir,oe_n,en,tm)
.include cplz_ls01_dut.spice
.include models_tt.spice
.param VL=1.2 VH=3.3
.temp 27
VDL vddl 0 {VL}
VDH vddh 0 {VH}
Vdir  dir  0 PWL(0 {0*VL} 39.9n {0*VL} 40n {0*VL} 79.9n {0*VL} 80n {0*VL} 119.9n {0*VL} 120n {0*VL} 159.9n {0*VL} 160n {1*VL} 199.9n {1*VL} 200n {1*VL} 239.9n {1*VL} 240n {1*VL} 279.9n {1*VL} 280n {1*VL} 319.9n {1*VL} 320n {0*VL} 359.9n {0*VL} 360n {0*VL} 399.9n {0*VL} 400n {0*VL} 439.9n {0*VL} 440n {0*VL} 479.9n {0*VL} 480n {1*VL} 519.9n {1*VL} 520n {1*VL} 559.9n {1*VL} 560n {1*VL} 599.9n {1*VL} 600n {1*VL})
Voe   oe_n 0 PWL(0 {0*VL} 39.9n {0*VL} 40n {0*VL} 79.9n {0*VL} 80n {1*VL} 119.9n {1*VL} 120n {1*VL} 159.9n {1*VL} 160n {0*VL} 199.9n {0*VL} 200n {0*VL} 239.9n {0*VL} 240n {1*VL} 279.9n {1*VL} 280n {1*VL} 319.9n {1*VL} 320n {0*VL} 359.9n {0*VL} 360n {0*VL} 399.9n {0*VL} 400n {1*VL} 439.9n {1*VL} 440n {1*VL} 479.9n {1*VL} 480n {0*VL} 519.9n {0*VL} 520n {0*VL} 559.9n {0*VL} 560n {1*VL} 599.9n {1*VL} 600n {1*VL})
Ven   en   0 PWL(0 {0*VL} 39.9n {0*VL} 40n {1*VL} 79.9n {1*VL} 80n {0*VL} 119.9n {0*VL} 120n {1*VL} 159.9n {1*VL} 160n {0*VL} 199.9n {0*VL} 200n {1*VL} 239.9n {1*VL} 240n {0*VL} 279.9n {0*VL} 280n {1*VL} 319.9n {1*VL} 320n {0*VL} 359.9n {0*VL} 360n {1*VL} 399.9n {1*VL} 400n {0*VL} 439.9n {0*VL} 440n {1*VL} 479.9n {1*VL} 480n {0*VL} 519.9n {0*VL} 520n {1*VL} 559.9n {1*VL} 560n {0*VL} 599.9n {0*VL} 600n {1*VL})
Vtm   tm   0 PWL(0 {0*VL} 39.9n {0*VL} 40n {0*VL} 79.9n {0*VL} 80n {0*VL} 119.9n {0*VL} 120n {0*VL} 159.9n {0*VL} 160n {0*VL} 199.9n {0*VL} 200n {0*VL} 239.9n {0*VL} 240n {0*VL} 279.9n {0*VL} 280n {0*VL} 319.9n {0*VL} 320n {1*VL} 359.9n {1*VL} 360n {1*VL} 399.9n {1*VL} 400n {1*VL} 439.9n {1*VL} 440n {1*VL} 479.9n {1*VL} 480n {1*VL} 519.9n {1*VL} 520n {1*VL} 559.9n {1*VL} 560n {1*VL} 599.9n {1*VL} 600n {1*VL})
Vaf a_pad 0 {VL/2}
Vbf b_pad 0 {VH/2}
XCH a_pad b_pad dir oe_n en tm ring_div vddl vddh 0 CH
.tran 50p 640n
* state  0: dir=0 oe_n=0 en=0 tm=0
.meas tran s00_enup AVG v(xch.en_up) FROM=30n TO=39n
.meas tran s00_ena AVG v(xch.en_a) FROM=30n TO=39n
.meas tran s00_pg AVG v(xch.pg) FROM=30n TO=39n
.meas tran s00_ng AVG v(xch.ng) FROM=30n TO=39n
.meas tran s00_apg AVG v(xch.apg) FROM=30n TO=39n
.meas tran s00_ang AVG v(xch.ang) FROM=30n TO=39n
.meas tran s00_ib RMS i(Vbf) FROM=30n TO=39n
.meas tran s00_ia RMS i(Vaf) FROM=30n TO=39n
* state  1: dir=0 oe_n=0 en=1 tm=0
.meas tran s01_enup AVG v(xch.en_up) FROM=70n TO=79n
.meas tran s01_ena AVG v(xch.en_a) FROM=70n TO=79n
.meas tran s01_pg AVG v(xch.pg) FROM=70n TO=79n
.meas tran s01_ng AVG v(xch.ng) FROM=70n TO=79n
.meas tran s01_apg AVG v(xch.apg) FROM=70n TO=79n
.meas tran s01_ang AVG v(xch.ang) FROM=70n TO=79n
.meas tran s01_ib RMS i(Vbf) FROM=70n TO=79n
.meas tran s01_ia RMS i(Vaf) FROM=70n TO=79n
* state  2: dir=0 oe_n=1 en=0 tm=0
.meas tran s02_enup AVG v(xch.en_up) FROM=110n TO=119n
.meas tran s02_ena AVG v(xch.en_a) FROM=110n TO=119n
.meas tran s02_pg AVG v(xch.pg) FROM=110n TO=119n
.meas tran s02_ng AVG v(xch.ng) FROM=110n TO=119n
.meas tran s02_apg AVG v(xch.apg) FROM=110n TO=119n
.meas tran s02_ang AVG v(xch.ang) FROM=110n TO=119n
.meas tran s02_ib RMS i(Vbf) FROM=110n TO=119n
.meas tran s02_ia RMS i(Vaf) FROM=110n TO=119n
* state  3: dir=0 oe_n=1 en=1 tm=0
.meas tran s03_enup AVG v(xch.en_up) FROM=150n TO=159n
.meas tran s03_ena AVG v(xch.en_a) FROM=150n TO=159n
.meas tran s03_pg AVG v(xch.pg) FROM=150n TO=159n
.meas tran s03_ng AVG v(xch.ng) FROM=150n TO=159n
.meas tran s03_apg AVG v(xch.apg) FROM=150n TO=159n
.meas tran s03_ang AVG v(xch.ang) FROM=150n TO=159n
.meas tran s03_ib RMS i(Vbf) FROM=150n TO=159n
.meas tran s03_ia RMS i(Vaf) FROM=150n TO=159n
* state  4: dir=1 oe_n=0 en=0 tm=0
.meas tran s04_enup AVG v(xch.en_up) FROM=190n TO=199n
.meas tran s04_ena AVG v(xch.en_a) FROM=190n TO=199n
.meas tran s04_pg AVG v(xch.pg) FROM=190n TO=199n
.meas tran s04_ng AVG v(xch.ng) FROM=190n TO=199n
.meas tran s04_apg AVG v(xch.apg) FROM=190n TO=199n
.meas tran s04_ang AVG v(xch.ang) FROM=190n TO=199n
.meas tran s04_ib RMS i(Vbf) FROM=190n TO=199n
.meas tran s04_ia RMS i(Vaf) FROM=190n TO=199n
* state  5: dir=1 oe_n=0 en=1 tm=0
.meas tran s05_enup AVG v(xch.en_up) FROM=230n TO=239n
.meas tran s05_ena AVG v(xch.en_a) FROM=230n TO=239n
.meas tran s05_pg AVG v(xch.pg) FROM=230n TO=239n
.meas tran s05_ng AVG v(xch.ng) FROM=230n TO=239n
.meas tran s05_apg AVG v(xch.apg) FROM=230n TO=239n
.meas tran s05_ang AVG v(xch.ang) FROM=230n TO=239n
.meas tran s05_ib RMS i(Vbf) FROM=230n TO=239n
.meas tran s05_ia RMS i(Vaf) FROM=230n TO=239n
* state  6: dir=1 oe_n=1 en=0 tm=0
.meas tran s06_enup AVG v(xch.en_up) FROM=270n TO=279n
.meas tran s06_ena AVG v(xch.en_a) FROM=270n TO=279n
.meas tran s06_pg AVG v(xch.pg) FROM=270n TO=279n
.meas tran s06_ng AVG v(xch.ng) FROM=270n TO=279n
.meas tran s06_apg AVG v(xch.apg) FROM=270n TO=279n
.meas tran s06_ang AVG v(xch.ang) FROM=270n TO=279n
.meas tran s06_ib RMS i(Vbf) FROM=270n TO=279n
.meas tran s06_ia RMS i(Vaf) FROM=270n TO=279n
* state  7: dir=1 oe_n=1 en=1 tm=0
.meas tran s07_enup AVG v(xch.en_up) FROM=310n TO=319n
.meas tran s07_ena AVG v(xch.en_a) FROM=310n TO=319n
.meas tran s07_pg AVG v(xch.pg) FROM=310n TO=319n
.meas tran s07_ng AVG v(xch.ng) FROM=310n TO=319n
.meas tran s07_apg AVG v(xch.apg) FROM=310n TO=319n
.meas tran s07_ang AVG v(xch.ang) FROM=310n TO=319n
.meas tran s07_ib RMS i(Vbf) FROM=310n TO=319n
.meas tran s07_ia RMS i(Vaf) FROM=310n TO=319n
* state  8: dir=0 oe_n=0 en=0 tm=1
.meas tran s08_enup AVG v(xch.en_up) FROM=350n TO=359n
.meas tran s08_ena AVG v(xch.en_a) FROM=350n TO=359n
.meas tran s08_pg AVG v(xch.pg) FROM=350n TO=359n
.meas tran s08_ng AVG v(xch.ng) FROM=350n TO=359n
.meas tran s08_apg AVG v(xch.apg) FROM=350n TO=359n
.meas tran s08_ang AVG v(xch.ang) FROM=350n TO=359n
.meas tran s08_ib RMS i(Vbf) FROM=350n TO=359n
.meas tran s08_ia RMS i(Vaf) FROM=350n TO=359n
* state  9: dir=0 oe_n=0 en=1 tm=1
.meas tran s09_enup AVG v(xch.en_up) FROM=390n TO=399n
.meas tran s09_ena AVG v(xch.en_a) FROM=390n TO=399n
.meas tran s09_pg AVG v(xch.pg) FROM=390n TO=399n
.meas tran s09_ng AVG v(xch.ng) FROM=390n TO=399n
.meas tran s09_apg AVG v(xch.apg) FROM=390n TO=399n
.meas tran s09_ang AVG v(xch.ang) FROM=390n TO=399n
.meas tran s09_ib RMS i(Vbf) FROM=390n TO=399n
.meas tran s09_ia RMS i(Vaf) FROM=390n TO=399n
* state 10: dir=0 oe_n=1 en=0 tm=1
.meas tran s10_enup AVG v(xch.en_up) FROM=430n TO=439n
.meas tran s10_ena AVG v(xch.en_a) FROM=430n TO=439n
.meas tran s10_pg AVG v(xch.pg) FROM=430n TO=439n
.meas tran s10_ng AVG v(xch.ng) FROM=430n TO=439n
.meas tran s10_apg AVG v(xch.apg) FROM=430n TO=439n
.meas tran s10_ang AVG v(xch.ang) FROM=430n TO=439n
.meas tran s10_ib RMS i(Vbf) FROM=430n TO=439n
.meas tran s10_ia RMS i(Vaf) FROM=430n TO=439n
* state 11: dir=0 oe_n=1 en=1 tm=1
.meas tran s11_enup AVG v(xch.en_up) FROM=470n TO=479n
.meas tran s11_ena AVG v(xch.en_a) FROM=470n TO=479n
.meas tran s11_pg AVG v(xch.pg) FROM=470n TO=479n
.meas tran s11_ng AVG v(xch.ng) FROM=470n TO=479n
.meas tran s11_apg AVG v(xch.apg) FROM=470n TO=479n
.meas tran s11_ang AVG v(xch.ang) FROM=470n TO=479n
.meas tran s11_ib RMS i(Vbf) FROM=470n TO=479n
.meas tran s11_ia RMS i(Vaf) FROM=470n TO=479n
* state 12: dir=1 oe_n=0 en=0 tm=1
.meas tran s12_enup AVG v(xch.en_up) FROM=510n TO=519n
.meas tran s12_ena AVG v(xch.en_a) FROM=510n TO=519n
.meas tran s12_pg AVG v(xch.pg) FROM=510n TO=519n
.meas tran s12_ng AVG v(xch.ng) FROM=510n TO=519n
.meas tran s12_apg AVG v(xch.apg) FROM=510n TO=519n
.meas tran s12_ang AVG v(xch.ang) FROM=510n TO=519n
.meas tran s12_ib RMS i(Vbf) FROM=510n TO=519n
.meas tran s12_ia RMS i(Vaf) FROM=510n TO=519n
* state 13: dir=1 oe_n=0 en=1 tm=1
.meas tran s13_enup AVG v(xch.en_up) FROM=550n TO=559n
.meas tran s13_ena AVG v(xch.en_a) FROM=550n TO=559n
.meas tran s13_pg AVG v(xch.pg) FROM=550n TO=559n
.meas tran s13_ng AVG v(xch.ng) FROM=550n TO=559n
.meas tran s13_apg AVG v(xch.apg) FROM=550n TO=559n
.meas tran s13_ang AVG v(xch.ang) FROM=550n TO=559n
.meas tran s13_ib RMS i(Vbf) FROM=550n TO=559n
.meas tran s13_ia RMS i(Vaf) FROM=550n TO=559n
* state 14: dir=1 oe_n=1 en=0 tm=1
.meas tran s14_enup AVG v(xch.en_up) FROM=590n TO=599n
.meas tran s14_ena AVG v(xch.en_a) FROM=590n TO=599n
.meas tran s14_pg AVG v(xch.pg) FROM=590n TO=599n
.meas tran s14_ng AVG v(xch.ng) FROM=590n TO=599n
.meas tran s14_apg AVG v(xch.apg) FROM=590n TO=599n
.meas tran s14_ang AVG v(xch.ang) FROM=590n TO=599n
.meas tran s14_ib RMS i(Vbf) FROM=590n TO=599n
.meas tran s14_ia RMS i(Vaf) FROM=590n TO=599n
* state 15: dir=1 oe_n=1 en=1 tm=1
.meas tran s15_enup AVG v(xch.en_up) FROM=630n TO=639n
.meas tran s15_ena AVG v(xch.en_a) FROM=630n TO=639n
.meas tran s15_pg AVG v(xch.pg) FROM=630n TO=639n
.meas tran s15_ng AVG v(xch.ng) FROM=630n TO=639n
.meas tran s15_apg AVG v(xch.apg) FROM=630n TO=639n
.meas tran s15_ang AVG v(xch.ang) FROM=630n TO=639n
.meas tran s15_ib RMS i(Vbf) FROM=630n TO=639n
.meas tran s15_ia RMS i(Vaf) FROM=630n TO=639n
.end
