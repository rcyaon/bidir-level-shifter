#!/usr/bin/env python3
import re,sys
STATES=[(dr,oen,en,tm) for tm in (0,1) for dr in (0,1) for oen in (0,1) for en in (0,1)]
vals={}
for L in open(sys.argv[1]):
    m=re.match(r"\s*(s\d\d_\w+)\s*=\s*([-\d.e+]+)",L)
    if m: vals[m.group(1)]=float(m.group(2))
VL,VH=1.2,3.3
print(f"{'#':>2} {'dir':>3}{'oe_n':>5}{'en':>3}{'tm':>3} | {'en_up':>6}{'exp':>4} {'en_a':>6}{'exp':>4} | "
      f"{'pg':>6}{'ng':>6} Bdrv {'apg':>6}{'ang':>6} Adrv | verdict")
fails=0
for i,(dr,oen,en,tm) in enumerate(STATES):
    n=f"s{i:02d}"; g=lambda k: vals.get(f"{n}_{k}",float('nan'))
    oe=1-oen
    e_up=int(((1-dr) or tm) and oe and en)
    e_a =int((dr or tm) and oe and en)
    m_up=int(g('enup')>VL/2); m_a=int(g('ena')>VL/2)
    # B driver tri-state <=> pg high AND ng low ; A driver <=> apg high AND ang low
    bz = (g('pg')>0.8*VH) and (g('ng')<0.2*VH)
    az = (g('apg')>0.8*VL) and (g('ang')<0.2*VL)
    ok = (m_up==e_up) and (m_a==e_a) and (bz == (e_up==0)) and (az == (e_a==0))
    if not ok: fails+=1
    print(f"{i:2d} {dr:>3}{oen:>5}{en:>3}{tm:>3} | {g('enup'):6.2f}{e_up:>4} {g('ena'):6.2f}{e_a:>4} | "
          f"{g('pg'):6.2f}{g('ng'):6.2f} {'HiZ ' if bz else 'DRV '} {g('apg'):6.2f}{g('ang'):6.2f} "
          f"{'HiZ ' if az else 'DRV '} | {'PASS' if ok else 'FAIL'}")
print(f"\nTB3 control truth table: {len(STATES)-fails}/{len(STATES)} states PASS")
sys.exit(1 if fails else 0)
