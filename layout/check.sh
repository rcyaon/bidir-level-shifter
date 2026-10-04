#!/bin/sh
# DRC (KLayout and magic) and LVS (KLayout) of layout cells, with a summary.
# Run in layout/ inside the container:  sh check.sh bidir_channel [muxlv ...]
# Reports go to $OUT (default /tmp/check/<cell>).
#
# LVS is hierarchical with tap extraction off (taps aren't in the
# schematics). The netlist is drc/schematics/<cell>.spice, or
# drc/symbols/<CELL>.spice for the gates.

export PDK_ROOT=${PDK_ROOT:-/foss/pdks} PDK=ihp-sg13cmos5l
K=$PDK_ROOT/$PDK/libs.tech/klayout
here=$(cd "$(dirname "$0")" && pwd)

for cell in "$@"; do
  out=${OUT:-/tmp/check}/$cell
  rm -rf "$out" && mkdir -p "$out"
  gds=$here/$cell.gds
  [ -f "$gds" ] || gds=$here/../gds/$cell.gds
  net=$here/drc/schematics/$cell.spice
  [ -f "$net" ] || net=$here/drc/symbols/$(echo "$cell" | tr a-z A-Z).spice

  python3 "$K/tech/drc/run_drc.py" --path="$gds" --topcell="$cell" --run_dir="$out/drc" \
    --mp=4 --no_density > "$out/drc.log" 2>&1
  drc=$(python3 - "$out"/drc/*_full.lyrdb <<'EOF'
import collections, re, sys
c = collections.Counter(re.findall(r"<item>.*?<category>'?(.*?)'?</category>", open(sys.argv[1]).read(), re.S))
print(", ".join(f"{k} x{v}" for k, v in sorted(c.items())) or "clean")
EOF
)

  python3 "$K/tech/lvs/run_lvs.py" --layout="$gds" --netlist="$net" --topcell="$cell" \
    --run_dir="$out/lvs" --run_mode=deep --disable_tap_extraction > "$out/lvs.log" 2>&1
  lvs=$(grep -q "PASS (netlists match)" "$out/lvs.log" && echo match || echo MISMATCH)

  cat > "$out/mdrc.tcl" <<EOF
crashbackups stop
drc off
gds read $gds
load $cell
select top cell
expand
drc style drc(full)
drc on
drc check
drc catchup
foreach {why boxes} [drc listall why] { puts "MDRC [llength \$boxes] \$why" }
quit -noprompt
EOF
  magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc" "$out/mdrc.tcl" \
    > "$out/magic.log" 2>&1
  mdrc=$(grep '^MDRC' "$out/magic.log" | sed 's/^MDRC //' | paste -sd ';' -)

  echo "$cell: KLayout DRC: $drc | LVS: $lvs | magic DRC: ${mdrc:-clean}"
done
