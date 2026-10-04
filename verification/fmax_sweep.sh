#!/bin/sh
# Highest toggle rate of bidir_channel per direction, pad load and corner.
# Runs tb_bidir_fmax at every rate in $FREQS and prints, per case, the
# highest rate that passes with every lower rate passing too, and the
# delays at the lowest rate.
# Run from the repo root inside IIC-OSIC-TOOLS:  sh verification/fmax_sweep.sh
# All corners take ~40 min on 8 cores (JOBS=8).
#
#   VIEW=pex        simulate the extracted layout (layout/pex.sh, C only)
#                   instead of the schematic
#   CORNERS_ONLY=tt run only the corners named (space-separated)
#   TABLE_ONLY=1    don't simulate, print the table from the last run

export PDK_ROOT=${PDK_ROOT:-/foss/pdks} PDK=ihp-sg13cmos5l
export OMP_NUM_THREADS=1      # one core per job; the jobs run in parallel
FREQS=${FREQS:-"25 50 75 100 125 150 175 200 250 300"}
LOADS=${LOADS:-"5e-12 0.5e-12"}
view=${VIEW:-sch}
sim=xschem/simulation
dir=fmax_$view

# corner  mos lib  vddl  vddh  temp
CORNERS="tt mos_tt 1.20 3.30 27
ss mos_ss 1.20 3.30 27
ff mos_ff 1.20 3.30 27
tt-10% mos_tt 1.08 2.97 27
ss-10%,125C mos_ss 1.08 2.97 125"
if [ -n "$CORNERS_ONLY" ]; then
  CORNERS=$(echo "$CORNERS" | awk -v only=" $CORNERS_ONLY " 'index(only, " " $1 " ")')
fi
tagname() { echo "$1" | tr -c 'a-z0-9\n' _; }

if [ -z "$TABLE_ONLY" ]; then
  xschem -n -s -q -x -o $sim verification/tb_bidir_fmax.sch > /dev/null 2>&1
  base=$sim/tb_bidir_fmax_$view.spice
  cp $sim/tb_bidir_fmax.spice $base
  if [ $view = pex ]; then
    (cd layout && sh pex.sh bidir_channel) || exit 1
    ports=$(grep -m1 '^.subckt bidir_channel_flat' $sim/bidir_channel_pex.spice | cut -d' ' -f3-)
    sed -i -e 's/^\.subckt bidir_channel /.subckt bidir_channel_sch /' \
      -e "s/^\.end$/.include bidir_channel_pex.spice\n.subckt bidir_channel a_pad b_pad dir oe_n en tm ring_div vddl vddh vss\nXPEX $ports bidir_channel_flat\n.ends\n.end/" $base
  fi
  mkdir -p $sim/$dir && rm -f $sim/$dir/*
  echo "$CORNERS" | while read tag lib vl vh t; do
    for cl in $LOADS; do for dv in 0 1; do for f in $FREQS; do
      n="$dir/$(tagname "$tag")_${cl}_${dv}_$f"
      sed -e "s/ mos_tt$/ $lib/" -e "s/^VDL vddl 0 1.2$/VDL vddl 0 $vl\n.temp $t/" \
          -e "s/^VDH vddh 0 3.3$/VDH vddh 0 $vh/" -e "s/^Ven en 0 PWL(0 0 3n 0 3.5n 1.2)/Ven en 0 PWL(0 0 3n 0 3.5n $vl)/" \
          -e "s/^let fr = .*/let fr = ${f}e6/" -e "s/^let cl = .*/let cl = $cl/" -e "s/^let dv = .*/let dv = $dv/" \
          -e "s/^write tb_bidir_fmax.raw$//" $base > $sim/$n.spice
      echo "$n"
    done; done; done
  done > $sim/$dir/cases
  (cd $sim && xargs -P ${JOBS:-8} -I{} sh -c 'timeout 1800 ngspice -b {}.spice > {}.log 2>&1' < $dir/cases)
fi

echo "bidir_channel ($view): highest passing toggle rate; delays at 25 MHz"
printf "%-12s %-5s %-4s %9s %8s %8s\n" corner load dir "fmax/MHz" "tpLH/ns" "tpHL/ns"
echo "$CORNERS" | while read tag rest; do
  for cl in $LOADS; do for dv in 0 1; do
    best=-; d=
    for f in $FREQS; do
      r=$(grep '^result' "$sim/$dir/$(tagname "$tag")_${cl}_${dv}_$f.log" 2>/dev/null)
      case "$r" in *pass=1*) best=$f; [ -z "$d" ] && d=$r ;; *) break ;; esac
    done
    tp() { echo "$d" | sed -n "s/.*$1=\([^ ]*\).*/\1/p" | awk '{printf "%.2f", $1 * 1e9}'; }
    printf "%-12s %-5s %-4s %9s %8s %8s\n" "$tag" "$(echo $cl | sed 's/e-12/p/')" \
      "$([ $dv = 0 ] && echo A-B || echo B-A)" "$best" "$(tp tplh)" "$(tp tphl)"
  done; done
done
