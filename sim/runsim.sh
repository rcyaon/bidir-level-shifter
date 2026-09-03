#!/bin/bash
# runsim.sh <deck.sp> -- run ngspice, print only measurements + real errors
f="$1"
out=$(ngspice -b "$f" 2>&1)
echo "$out" | grep -iE "^(Error|fatal|Warning: singular|doAnalyses:)" | head -10
echo "$out" | awk '/Measurements for/{m=1;next} /Total analysis time/{m=0} m && /=/'
