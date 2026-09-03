#!/usr/bin/env python3
import re,sys
PAT=open("prbs_pattern.txt").read().strip()
fn=sys.argv[1]; res=open(fn).read()
hi=float(sys.argv[2]); errs=[]; n=0
for m in re.finditer(r"b(\d\d)\s*=\s*([-\d.e+]+)",res):
    i=int(m.group(1)); v=float(m.group(2)); exp=int(PAT[i]); got=1 if v>hi/2 else 0
    n+=1
    if got!=exp: errs.append((i,exp,got,v))
print(f"{fn}: {n-len(errs)}/{n} bits correct", "PASS" if not errs and n else "FAIL")
for i,e,g,v in errs[:8]: print(f"   bit {i}: expected {e} got {g} (v={v:.3f})")
