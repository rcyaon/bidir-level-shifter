#!/usr/bin/env python3
import re,glob,sys
rows={}
for f in glob.glob("pvt_*.res"):
    m=re.match(r"pvt_(fwd|rev)_(\w\w)_(-?\d+)C_(\d+)\.sp\.res",f)
    if not m: continue
    d,c,t,s=m.group(1),m.group(2),int(m.group(3)),int(m.group(4))
    v={k:float(val) for k,val in re.findall(r"(\w+)\s*=\s*([-\d.e+]+)",open(f).read())}
    rows[(d,c,t,s)]=v
for d,label in (("fwd","FORWARD  A(1.2V) -> B(3.3V)"),("rev","REVERSE  B(3.3V) -> A(1.2V)")):
    print(f"\n=== {label} ===")
    print(f"{'corner':>6}{'temp':>6}{'supply':>8} | {'tpdLH':>8}{'tpdHL':>8}{'trise':>8}{'tfall':>8} | {'VOH':>7}{'VOL':>8} | {'IDDavg':>10}")
    print(f"{'':>6}{'':>6}{'':>8} | {'ns':>8}{'ns':>8}{'ns':>8}{'ns':>8} | {'V':>7}{'mV':>8} | {'mA':>10}")
    ks=sorted([k for k in rows if k[0]==d],key=lambda k:(k[1],k[2]))
    worst_t=0; bad=[]
    for k in ks:
        v=rows[k]; _,c,t,s=k
        try:
            tl,th=v['tpdlh']*1e9,v['tpdhl']*1e9
            idd=abs(v['iddh_avg'] if d=='fwd' else v['iddl_avg'])*1e3
            voh,vol=v['voh'],v['vol']*1e3
            worst_t=max(worst_t,tl,th)
            rail = 3.3*s/100 if d=='fwd' else 1.2*s/100
            if voh < 0.9*rail or vol > 0.1*rail*1000: bad.append(k)
            print(f"{c:>6}{t:>5}C{s:>7}% | {tl:8.2f}{th:8.2f}{v['trise']*1e9:8.2f}{v['tfall']*1e9:8.2f} | {voh:7.3f}{vol:8.3f} | {idd:10.3f}")
        except KeyError as e:
            print(f"{c:>6}{t:>5}C{s:>7}% |  *** measurement missing: {e} ***"); bad.append(k)
    print(f"  worst-case tpd across all {len(ks)} corners: {worst_t:.2f} ns")
    print(f"  level integrity: {'ALL PASS' if not bad else 'FAIL at '+str(bad)}")
