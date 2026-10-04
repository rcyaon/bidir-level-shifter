#!/bin/sh
# Extract a cell with its parasitic capacitances (magic, flattened) for
# post-layout simulation. Resistance is not extracted.
# Run in layout/ inside the container:  sh pex.sh bidir_channel
# Writes ../xschem/simulation/<cell>_pex.spice with subckt <cell>_flat.

export PDK_ROOT=${PDK_ROOT:-/foss/pdks} PDK=ihp-sg13cmos5l
cell=${1:-bidir_channel}
here=$(cd "$(dirname "$0")" && pwd)
out=$here/../xschem/simulation
run=$(mktemp -d)
mkdir -p "$out"
cat > "$run/pex.tcl" <<EOF
crashbackups stop
drc off
gds read $here/$cell.gds
load $cell
select top cell
flatten ${cell}_flat
load ${cell}_flat
extract do local
extract all
ext2spice lvs
ext2spice cthresh 0.01
ext2spice -o $out/${cell}_pex.spice
quit -noprompt
EOF
(cd "$run" && magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc" pex.tcl > pex.log 2>&1)
# magic writes rppd without its bend count, which the PDK model needs
sed -i 's/ rppd \(l=[^ ]* w=[^ ]*\)$/ rppd \1 b=0 m=1/' "$out/${cell}_pex.spice"
# drop capacitors on nodes with no device or port (bits of the resistor
# body): they have no DC path and make the operating point singular
awk 'NR == FNR { if ($1 ~ /^X/) for (i = 2; i <= NF && $i !~ /=/; i++) dc[$i] = 1
                 if ($1 == ".subckt") for (i = 3; i <= NF; i++) dc[$i] = 1; next }
     $1 ~ /^C/ && (!($2 in dc) || !($3 in dc)) { next } { print }' \
  "$out/${cell}_pex.spice" "$out/${cell}_pex.spice" > "$run/pex.spice" && mv "$run/pex.spice" "$out/${cell}_pex.spice"
echo "pex: $(grep -cE '^X' "$out/${cell}_pex.spice") devices, $(grep -cE '^C' "$out/${cell}_pex.spice") capacitors in $out/${cell}_pex.spice"
echo "pex: ports $(grep -m1 '^.subckt' "$out/${cell}_pex.spice" | cut -d' ' -f3-)"
