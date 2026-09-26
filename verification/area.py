# Rough area from the netlist: sum of device boxes x 2.5 (wells, spacing,
# routing) + caps as MOS caps at 8 fF/um^2.  Not a layout number.
# Usage: python3 verification/area.py xschem/simulation/tb_bidir_channel.spice
import re, sys
txt=open(sys.argv[1]).read()
subs={}
for m in re.finditer(r'^\.subckt (\S+).*?\n(.*?)^\.ends',txt,re.M|re.S):
    subs[m.group(1)]=m.group(2)
def num(v):
    v=v.lower().rstrip('m')
    mult={'u':1,'n':1e-3,'p':1e-6}
    return float(v[:-1])*mult[v[-1]] if v[-1] in mult else float(v)
def walk(c):
    r=dict(nlv=0,nhv=0,gate=0.0,fp=0.0,C=0.0,R=0)
    for l in subs[c].splitlines():
        t=l.split()
        if not t or t[0][0] in '*.': continue
        if t[0][0] in 'Xx':
            if len(t)>5 and t[5].startswith('sg13_'):
                p=dict(kv.split('=') for kv in t[6:] if '=' in kv)
                w=num(p['w']); L=num(p['l']); m=int(p.get('m','1'))
                hv='hv' in t[5]
                r['nhv' if hv else 'nlv']+=m
                r['gate']+=w*L*m
                # device box: gate + source/drain contacts + spacing (um)
                r['fp']+=(w+(0.6 if hv else 0.4))*(L+(1.4 if hv else 0.9))*m
            else:
                sub=walk(t[-1])
                for k in r: r[k]+=sub[k]
        elif t[0][0] in 'Cc': r['C']+=float(t[3].rstrip('pP'))*1e3
        elif t[0][0] in 'Rr': r['R']+=1
    return r
for c in ['delay_2ns','dff_c2mos','divider_16','level_shifter_up','bidir_channel']:
    r=walk(c)
    capA=r['C']/8  # fF / 8 fF/um2, MOS cap
    est=2.5*r['fp']+capA+ (r['R']*20)
    print(f"{c:18s} LV={r['nlv']:3d} HV={r['nhv']:3d} gate={r['gate']:7.1f} fp={r['fp']:7.1f} C={r['C']:.0f}fF capA={capA:.0f} est={est:.0f} um2")
