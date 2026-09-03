#!/bin/bash
cd /foss/designs/cplz_ls01_xschem/sim
ls pvt_*.sp | xargs -P 4 -I{} bash -c 'ngspice -b {} 2>&1 | awk "/Measurements for/{m=1;next} /Total analysis/{m=0} m&&/=/" > {}.res'
