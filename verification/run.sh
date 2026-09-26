#!/bin/sh
# Simulate every testbench here and save an xschem screenshot of each.
# Run from the repo root inside IIC-OSIC-TOOLS:  sh verification/run.sh

export PDK_ROOT=${PDK_ROOT:-/foss/pdks} PDK=ihp-sg13cmos5l
sim=xschem/simulation
mkdir -p $sim
for sch in ${@:-verification/tb_*.sch}; do
  tb=$(basename $sch .sch)
  xschem -n -s -q -x -o $sim $sch
  (cd $sim && ngspice -b $tb.spice > $tb.log 2>&1)
  grep -iE '^[a-z_]+ *= ' $sim/$tb.log || true
  xvfb-run -a -s "-screen 0 1920x1080x24" \
    xschem -q --tcl 'wm geometry . 1800x900' \
      --command "xschem zoom_full; xschem print png $PWD/verification/$tb.png 1800 900; exit 0" $sch
done
