#!/usr/bin/env python3
"""
plot_results.py -- render the CPLZ-LS01 ngspice results as PNGs.

Runs each transient deck under ngspice -b -r, parses the binary rawfile and
the .meas output, and writes one PNG per view into results/.
Corner and data-rate figures are built from the .sp.res files already in
this directory (produced by runsim.sh).

Usage:  python3 plot_results.py [figure ...]      (no args = all figures)
"""
import os
import re
import glob
import subprocess
import sys

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "results")
os.makedirs(OUT, exist_ok=True)

VL, VH = 1.2, 3.3

# consistent palette across every figure
C_A = "#0072B2"   # A side / 1.2 V domain
C_B = "#D55E00"   # B side / 3.3 V domain
C_C = "#009E73"   # control / enables
C_D = "#CC79A7"   # secondary control
C_K = "#333333"

plt.rcParams.update({
    "figure.dpi": 130,
    "savefig.dpi": 130,
    "font.size": 9,
    "axes.titlesize": 10,
    "axes.titleweight": "bold",
    "axes.labelsize": 9,
    "axes.grid": True,
    "grid.alpha": 0.25,
    "grid.linewidth": 0.6,
    "axes.axisbelow": True,
    "legend.frameon": False,
    "legend.fontsize": 8,
    "axes.spines.top": False,
    "axes.spines.right": False,
})


# --------------------------------------------------------------- ngspice ---
def read_raw(path):
    """Parse an ngspice binary rawfile into {vector name: ndarray}."""
    with open(path, "rb") as fh:
        blob = fh.read()
    tag = b"Binary:\n"
    cut = blob.index(tag)
    header = blob[:cut].decode("utf-8", "replace")
    nvars = int(re.search(r"No\. Variables:\s*(\d+)", header).group(1))
    npts = int(re.search(r"No\. Points:\s*(\d+)", header).group(1))
    table = header.split("\nVariables:\n", 1)[1]
    names = re.findall(r"^\s*\d+\s+(\S+)\s+\S+", table, re.M)[:nvars]
    data = np.frombuffer(blob[cut + len(tag):], dtype="<f8", count=nvars * npts)
    data = data.reshape(npts, nvars)
    return {n: data[:, i] for i, n in enumerate(names)}


def parse_meas(txt):
    """Pull .meas results out of ngspice batch output.

    A line reads e.g.
        tpdlh   =  2.16928e-09 targ=  6.22693e-08 trig=  6.01000e-08
    so trig/targ are kept as <name>_trig / <name>_targ for annotation.
    """
    out = {}
    num = r"[-+]?[\d.]+(?:[eE][-+]?\d+)?"
    for line in txt.splitlines():
        mm = re.match(rf"^(\w+)\s*=\s*({num})", line)
        if not mm or mm.group(1) in ("Reference", "No"):
            continue
        name = mm.group(1)
        try:
            out[name] = float(mm.group(2))
        except ValueError:
            continue
        for key in ("targ", "trig", "at", "from", "to"):
            kv = re.search(rf"\b{key}\s*=\s*({num})", line)
            if kv:
                out[f"{name}_{key}"] = float(kv.group(1))
    return out


def run(deck, raw=None):
    """Run a deck twice: once for waveforms (-r), once for .meas results.

    ngspice refuses to evaluate .meas in batch mode when a rawfile is
    requested, so the two outputs cannot come from a single invocation.
    """
    raw = raw or os.path.join("/tmp", os.path.basename(deck) + ".raw")
    wave = subprocess.run(["ngspice", "-b", "-r", raw, deck],
                          cwd=HERE, capture_output=True, text=True)
    if not os.path.exists(raw):
        raise RuntimeError(f"{deck}: no rawfile produced\n"
                           f"{(wave.stdout + wave.stderr)[-2000:]}")
    mrun = subprocess.run(["ngspice", "-b", deck],
                          cwd=HERE, capture_output=True, text=True)
    meas = parse_meas(mrun.stdout + mrun.stderr)
    print(f"  ran {deck}  ({len(meas)} measurements)")
    return read_raw(raw), meas


def res_meas(path):
    """Parse a .sp.res file written by runsim.sh."""
    with open(path) as fh:
        return parse_meas(fh.read())


def save(fig, name, note=None):
    if note:
        fig.text(0.995, -0.025, note, ha="right", va="top",
                 fontsize=6.5, color="#888888")
    path = os.path.join(OUT, name)
    fig.savefig(path, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    print(f"  -> results/{name}")


FOOT = "CPLZ-LS01 · IHP SG13G2 (SG13CMOS5L) PSP103.6 models · ngspice-47"


def fmt_v(x):
    """Render a voltage with units that stay readable down to nanovolts."""
    a = abs(x)
    if a >= 1e-2:
        return f"{x:.3f} V"
    if a >= 1e-5:
        return f"{x*1e3:.3f} mV"
    if a >= 1e-8:
        return f"{x*1e6:.2f} \u00b5V"
    return f"{x*1e9:.2f} nV"


def digital(ax, t, v, rail, label, color, offset):
    """Draw one logic trace on a stacked digital view."""
    ax.plot(t, v / rail * 0.8 + offset, color=color, lw=1.1)
    ax.text(-0.012, offset + 0.4, label, transform=ax.get_yaxis_transform(),
            ha="right", va="center", fontsize=8, color=color)


# ------------------------------------------------------------- figure 01 ---
def fig_forward():
    v, m = run("tb1_fwd.sp")
    t = v["time"] * 1e9
    fig, (ax, ax2) = plt.subplots(2, 1, figsize=(8.4, 4.8), sharex=True,
                                  gridspec_kw={"height_ratios": [3, 1.4]})
    ax.plot(t, v["v(a_pad)"], color=C_A, lw=1.4, label="a_pad  (1.2 V core)")
    ax.plot(t, v["v(b_pad)"], color=C_B, lw=1.4, label="b_pad  (3.3 V I/O, 5 pF)")
    ax.axhline(VL / 2, color=C_A, ls=":", lw=0.8)
    ax.axhline(VH / 2, color=C_B, ls=":", lw=0.8)
    ax.set_ylabel("volts")
    ax.set_title("Forward path — 1.2 V in, 3.3 V out  (dir = 0, en = 1, 50 Mb/s)")
    ax.legend(loc="upper right", ncol=2)
    ax.set_ylim(-0.3, 4.5)

    # annotate one propagation delay
    trig, targ = m.get("tpdlh_trig"), m.get("tpdlh_targ")
    if trig is None:
        trig, targ = 60.1e-9, 60.1e-9 + m["tpdlh"]
    ax.annotate("", xy=(targ * 1e9, VH / 2), xytext=(trig * 1e9, VH / 2),
                arrowprops=dict(arrowstyle="<->", color=C_K, lw=1.0))
    ax.text((trig + targ) / 2 * 1e9, VH / 2 + 0.22,
            f"$t_{{pdLH}}$ = {m['tpdlh']*1e9:.2f} ns", ha="center", fontsize=8)

    ax2.plot(t, v["i(vdh)"] * -1e3, color=C_B, lw=1.0, label="I(VDDH)")
    ax2.plot(t, v["i(vdl)"] * -1e3, color=C_A, lw=1.0, label="I(VDDL)")
    ax2.set_ylabel("mA")
    ax2.set_xlabel("time (ns)")
    ax2.legend(loc="upper right", ncol=2)
    ax2.set_xlim(50, 100)

    txt = (f"$t_{{pdLH}}$ {m['tpdlh']*1e9:.2f} ns   "
           f"$t_{{pdHL}}$ {m['tpdhl']*1e9:.2f} ns   "
           f"$t_r$ {m['trise']*1e9:.2f} ns   $t_f$ {m['tfall']*1e9:.2f} ns\n"
           f"$V_{{OH}}$ {m['voh']:.3f} V   $V_{{OL}}$ {fmt_v(m['vol'])}   "
           f"$I_{{DDH,avg}}$ {abs(m['iddh_avg'])*1e3:.3f} mA")
    ax.text(0.015, 0.97, txt, transform=ax.transAxes, fontsize=7, va="top",
            bbox=dict(boxstyle="round,pad=0.35", fc="#f5f5f5", ec="#cccccc"))
    save(fig, "01_forward_1v2_to_3v3.png", FOOT)


# ------------------------------------------------------------- figure 02 ---
def fig_reverse():
    v, m = run("tb2_rev.sp")
    t = v["time"] * 1e9
    fig, (ax, ax2) = plt.subplots(2, 1, figsize=(8.4, 4.8), sharex=True,
                                  gridspec_kw={"height_ratios": [3, 1.4]})
    ax.plot(t, v["v(b_pad)"], color=C_B, lw=1.4, label="b_pad  (3.3 V I/O)")
    ax.plot(t, v["v(a_pad)"], color=C_A, lw=1.4, label="a_pad  (1.2 V core, 5 pF)")
    ax.axhline(VH / 2, color=C_B, ls=":", lw=0.8)
    ax.axhline(VL / 2, color=C_A, ls=":", lw=0.8)
    ax.set_ylabel("volts")
    ax.set_title("Reverse path — 3.3 V in, 1.2 V out  (dir = 1, en = 1, 50 Mb/s)")
    ax.legend(loc="upper right", ncol=2)
    ax.set_ylim(-0.3, 4.5)

    trig, targ = m.get("tpdlh_trig"), m.get("tpdlh_targ")
    if trig is None:
        trig, targ = 60.15e-9, 60.15e-9 + m["tpdlh"]
    ax.annotate("", xy=(targ * 1e9, VL / 2), xytext=(trig * 1e9, VL / 2),
                arrowprops=dict(arrowstyle="<->", color=C_K, lw=1.0))
    ax.text((trig + targ) / 2 * 1e9, VL / 2 + 0.22,
            f"$t_{{pdLH}}$ = {m['tpdlh']*1e9:.2f} ns", ha="center", fontsize=8)

    ax2.plot(t, v["i(vdh)"] * -1e3, color=C_B, lw=1.0, label="I(VDDH)")
    ax2.plot(t, v["i(vdl)"] * -1e3, color=C_A, lw=1.0, label="I(VDDL)")
    ax2.set_ylabel("mA")
    ax2.set_xlabel("time (ns)")
    ax2.legend(loc="upper right", ncol=2)
    ax2.set_xlim(50, 100)

    txt = (f"$t_{{pdLH}}$ {m['tpdlh']*1e9:.2f} ns   "
           f"$t_{{pdHL}}$ {m['tpdhl']*1e9:.2f} ns   "
           f"$t_r$ {m['trise']*1e9:.2f} ns   $t_f$ {m['tfall']*1e9:.2f} ns\n"
           f"$V_{{OH}}$ {m['voh']:.3f} V   $V_{{OL}}$ {fmt_v(m['vol'])}   "
           f"$I_{{DDL,avg}}$ {abs(m['iddl_avg'])*1e3:.3f} mA")
    ax.text(0.015, 0.97, txt, transform=ax.transAxes, fontsize=7, va="top",
            bbox=dict(boxstyle="round,pad=0.35", fc="#f5f5f5", ec="#cccccc"))
    save(fig, "02_reverse_3v3_to_1v2.png", FOOT)


# ------------------------------------------------------------- figure 03 ---
def fig_dirflip():
    v, m = run("tb5_dirflip.sp")
    t = v["time"] * 1e9
    fig, axes = plt.subplots(3, 1, figsize=(7.4, 5.4), sharex=True,
                             gridspec_kw={"height_ratios": [1.1, 2, 1.6]})

    ax0, ax1, ax2 = axes
    ax0.plot(t, v["v(dir)"], color=C_K, lw=1.3)
    ax0.set_ylabel("dir (V)")
    ax0.set_yticks([0, VL])
    ax0.set_title("Direction reversal — break-before-make dead time")

    ax1.plot(t, v["v(xch.en_up)"], color=C_B, lw=1.4, label="en_up  (A→B driver arm)")
    ax1.plot(t, v["v(xch.en_a)"], color=C_A, lw=1.4, label="en_a   (B→A driver arm)")
    ax1.set_ylabel("volts")
    ax1.legend(loc="center right")
    ax1.set_ylim(-0.15, 1.55)

    for key_off, key_on, dead, x in (
            ("t_enup_off", "t_ena_on", "dead_f2r", 100),
            ("t_ena_off", "t_enup_on", "dead_r2f", 200)):
        if key_off in m and key_on in m:
            a, b = m[key_off] * 1e9, m[key_on] * 1e9
            ax1.axvspan(a, b, color="#999999", alpha=0.22, lw=0)
            ax1.annotate(f"dead time\n{m[dead]*1e9:.2f} ns",
                         xy=((a + b) / 2, 1.32), ha="center", fontsize=7.5)

    ax2.plot(t, v["i(vdh)"] * -1e3, color=C_B, lw=1.0, label="I(VDDH)")
    ax2.plot(t, v["i(vdl)"] * -1e3, color=C_A, lw=1.0, label="I(VDDL)")
    ax2.set_ylabel("mA")
    ax2.set_xlabel("time (ns)")
    ax2.legend(loc="upper right", ncol=2)
    ax2.set_xlim(90, 230)

    note = ("Both driver arms are off through the shaded window — "
            "no A-side and B-side contention during the flip.")
    ax2.text(0.015, 0.06, note, transform=ax2.transAxes, fontsize=7.5,
             bbox=dict(boxstyle="round,pad=0.35", fc="#f5f5f5", ec="#cccccc"))
    save(fig, "03_direction_flip_deadtime.png", FOOT)


# ------------------------------------------------------------- figure 04 ---
def fig_truthtable():
    v, m = run("tb3_truthtable.sp")
    t = v["time"] * 1e9
    fig, (ax, axm) = plt.subplots(2, 1, figsize=(8.6, 9.2),
                                  gridspec_kw={"height_ratios": [3, 3.4]})
    fig.subplots_adjust(hspace=0.28)

    traces = [("v(tm)", "tm", C_D, VL), ("v(en)", "en", C_C, VL),
              ("v(oe_n)", "oe_n", C_C, VL), ("v(dir)", "dir", C_K, VL),
              ("v(xch.en_up)", "en_up", C_B, VL),
              ("v(xch.en_a)", "en_a", C_A, VL),
              ("v(xch.pg)", "pg", C_B, VH), ("v(xch.ng)", "ng", C_B, VH),
              ("v(xch.apg)", "apg", C_A, VL), ("v(xch.ang)", "ang", C_A, VL)]
    for i, (key, lab, col, rail) in enumerate(traces):
        digital(ax, t, v[key], rail, lab, col, (len(traces) - 1 - i) * 1.0)
    for x in range(40, 641, 40):
        ax.axvline(x, color="#dddddd", lw=0.6, zorder=0)
    ax.set_yticks([])
    ax.set_xlim(0, 640)
    ax.set_xlabel("time (ns)   —   16 control states, 40 ns each")
    ax.set_title("Control truth table — inputs (dir, oe_n, en, tm) vs internal "
                 "driver enables")
    ax.set_ylim(-0.3, len(traces))

    # decoded state table from the .meas values
    states = []
    for s in range(16):
        p = f"s{s:02d}_"
        if p + "enup" not in m:
            continue
        d, o, e, tmv = (s >> 3) & 1, (s >> 2) & 1, (s >> 1) & 1, s & 1
        # state index order in the deck: dir, oe_n, en, tm walk as below
        d = 1 if s in (4, 5, 6, 7, 12, 13, 14, 15) else 0
        o = 1 if s in (2, 3, 6, 7, 10, 11, 14, 15) else 0
        e = 1 if s % 2 else 0
        tmv = 1 if s >= 8 else 0
        up = m[p + "enup"] > VL / 2
        a = m[p + "ena"] > VL / 2
        if up and a:
            mode = "test (ring)"
        elif up:
            mode = "A → B"
        elif a:
            mode = "B → A"
        else:
            mode = "Hi-Z"
        states.append((s, d, o, e, tmv, int(up), int(a), mode,
                       abs(m.get(p + "ib", 0)) * 1e6, abs(m.get(p + "ia", 0)) * 1e6))

    axm.axis("off")
    cols = ["#", "dir", "oe_n", "en", "tm", "en_up", "en_a", "channel",
            "I(b_pad)\nµA", "I(a_pad)\nµA"]
    cells = [[f"{s}", f"{d}", f"{o}", f"{e}", f"{tv}", f"{u}", f"{aa}", mo,
              f"{ib:.2f}", f"{ia:.2f}"]
             for s, d, o, e, tv, u, aa, mo, ib, ia in states]
    tab = axm.table(cellText=cells, colLabels=cols, loc="center", cellLoc="center")
    tab.auto_set_font_size(False)
    tab.set_fontsize(7)
    tab.scale(1, 1.32)
    for (r, c), cell in tab.get_celld().items():
        cell.set_linewidth(0.4)
        cell.set_edgecolor("#cccccc")
        if r == 0:
            cell.set_facecolor("#eeeeee")
            cell.set_text_props(weight="bold")
        elif c == 7:
            mo = cells[r - 1][7]
            cell.set_facecolor({"A → B": "#fdece3", "B → A": "#e3eff7",
                                "test (ring)": "#eaf6ef",
                                "Hi-Z": "#f2f2f2"}[mo])
    save(fig, "04_control_truth_table.png", FOOT)


# ------------------------------------------------------------- figure 05 ---
def fig_leakage():
    v, m = run("tb4_leak.sp")
    combos = [("a=0 b=0", "a0b0"), ("a=1 b=0", "a1b0"),
              ("a=0 b=1", "a0b1"), ("a=1 b=1", "a1b1")]
    idl = [abs(m[f"iddl_{k}"]) * 1e9 for _, k in combos]
    idh = [abs(m[f"iddh_{k}"]) * 1e9 for _, k in combos]

    fig, (ax, ax2) = plt.subplots(1, 2, figsize=(8.2, 3.4),
                                  gridspec_kw={"width_ratios": [1.35, 1]})
    x = np.arange(len(combos))
    ax.bar(x - 0.19, idl, 0.36, color=C_A, label="I(VDDL)  1.2 V rail")
    ax.bar(x + 0.19, idh, 0.36, color=C_B, label="I(VDDH)  3.3 V rail")
    ax.set_yscale("log")
    ax.set_xticks(x, [c for c, _ in combos])
    ax.set_ylabel("quiescent current (nA)")
    ax.set_title("Shutdown leakage  (en = 0, oe_n = 1)")
    ax.legend(loc="upper left")
    for xi, (l, h) in enumerate(zip(idl, idh)):
        ax.text(xi - 0.19, l * 1.25, f"{l:.1f}", ha="center", fontsize=7)
        ax.text(xi + 0.19, h * 1.25, f"{h:.1f}", ha="center", fontsize=7)
    ax.set_ylim(top=max(idl + idh) * 8)

    t = v["time"] * 1e9
    ax2.plot(t, v["v(a_pad)"], color=C_A, lw=1.2, label="a_pad")
    ax2.plot(t, v["v(b_pad)"], color=C_B, lw=1.2, label="b_pad")
    ax2.set_xlabel("time (ns)")
    ax2.set_ylabel("volts")
    ax2.set_title("pad states swept while disabled")
    ax2.legend(loc="upper left")

    tot = max(i * 1.2e-9 for i in idl) + max(i * 3.3e-9 for i in idh)
    ax.set_xlabel(f"worst-case static power in shutdown: "
                  f"{tot*1e9:.2f} nW per channel")
    save(fig, "05_shutdown_leakage.png", FOOT)


# ------------------------------------------------------------- figure 06 ---
def fig_schmitt():
    v, m = run("tb7_schmitt.sp")
    a, y, t = v["v(a)"], v["v(y)"], v["time"]
    up, dn = t <= 1e-6, t >= 1e-6
    fig, ax = plt.subplots(figsize=(5.2, 4.0))
    ax.plot(a[up], y[up], color=C_A, lw=1.6, label="input rising")
    ax.plot(a[dn], y[dn], color=C_B, lw=1.6, label="input falling")
    ax.axhline(VL / 2, color="#999999", ls=":", lw=0.8)
    for key, col, lab, dx in (("vil", C_B, "$V_{IL}$", -0.02),
                              ("vih", C_A, "$V_{IH}$", 0.02)):
        if key in m:
            ax.axvline(m[key], color=col, ls="--", lw=0.9)
            ax.text(m[key] + dx, 1.28, f"{lab}\n{m[key]*1e3:.0f} mV",
                    ha="right" if dx < 0 else "left", fontsize=7.5, color=col)
    ax.set_xlabel("SCHMLV input (V)")
    ax.set_ylabel("SCHMLV output (V)")
    ax.set_title("Input receiver hysteresis\n(SCHMLV inverting Schmitt trigger, 1.2 V)")
    ax.legend(loc="center left")
    ax.set_ylim(-0.1, 1.45)
    if "vhyst" in m:
        ax.text(0.5, 0.42, f"hysteresis = {abs(m['vhyst'])*1e3:.0f} mV",
                transform=ax.transAxes, ha="center", fontsize=8.5,
                bbox=dict(boxstyle="round,pad=0.35", fc="#f5f5f5", ec="#cccccc"))
    save(fig, "06_schmitt_hysteresis.png", FOOT)


# ------------------------------------------------------------- figure 07 ---
def fig_dc_transfer():
    fig, axes = plt.subplots(1, 2, figsize=(8.4, 3.8))
    for ax, deck, xin, yout, xr, yr, title in (
            (axes[0], "tb13_thresh_fwd.sp", "v(a_pad)", "v(b_pad)", VL, VH,
             "Forward  a_pad → b_pad"),
            (axes[1], "tb13_thresh_rev.sp", "v(b_pad)", "v(a_pad)", VH, VL,
             "Reverse  b_pad → a_pad")):
        v, m = run(deck)
        x, y, t = v[xin], v[yout], v["time"]
        half = t <= t.max() / 2
        ax.plot(x[half], y[half], color=C_A, lw=1.5, label="input rising")
        ax.plot(x[~half], y[~half], color=C_B, lw=1.5, label="input falling")
        # stagger the two labels -- the reverse trips sit <50 mV apart
        for key, col, lab, ha, yf in (("vil", C_B, "$V_{IL}$", "right", 1.11),
                                      ("vih", C_A, "$V_{IH}$", "left", 1.02)):
            if key in m:
                ax.axvline(m[key], color=col, ls="--", lw=0.9)
                pad = (0.012 if ha == "left" else -0.012) * xr
                ax.text(m[key] + pad, yr * yf, f"{lab} {m[key]*1e3:.0f} mV",
                        ha=ha, fontsize=7, color=col)
        ax.set_xlim(0, xr)
        ax.set_ylim(-0.05 * yr, yr * 1.24)
        ax.set_xlabel(f"{xin[2:-1]} (V)")
        ax.set_ylabel(f"{yout[2:-1]} (V)")
        ax.set_title(title)
        ax.legend(loc="center left")
        if "vhyst" in m:
            ax.text(0.97, 0.06, f"hysteresis {abs(m['vhyst'])*1e3:.0f} mV\n"
                                f"NM$_L$ {m.get('nm_low', 0)*1e3:.0f} mV   "
                                f"NM$_H$ {m.get('nm_high', 0)*1e3:.0f} mV",
                    transform=ax.transAxes, ha="right", fontsize=7.5,
                    bbox=dict(boxstyle="round,pad=0.3", fc="#f5f5f5", ec="#cccccc"))
    fig.suptitle("Channel DC transfer and input thresholds", y=1.0,
                 fontsize=10, fontweight="bold")
    save(fig, "07_dc_transfer_thresholds.png", FOOT)


# ------------------------------------------------------------- figure 08 ---
def fig_eye():
    v, _ = run("tb12_fwd_2p5ns.sp")
    t, b = v["time"], v["v(b_pad)"]
    ui = 2.5e-9
    fig, (ax, ax2) = plt.subplots(1, 2, figsize=(8.6, 3.7))

    # fold b_pad onto two unit intervals, skipping the first bit
    start, span = 5e-9, 2 * ui
    tt = np.arange(start, t.max() - span, ui)
    for t0 in tt:
        sel = (t >= t0) & (t <= t0 + span)
        if sel.sum() < 4:
            continue
        ax.plot((t[sel] - t0) * 1e9, b[sel], color=C_B, lw=0.7, alpha=0.5)
    ax.set_xlabel("time within eye (ns)")
    ax.set_ylabel("b_pad (V)")
    ax.set_title("Eye at b_pad — PRBS5, 400 Mb/s (UI = 2.5 ns), 5 pF")
    ax.set_xlim(0, span * 1e9)
    ax.axhline(VH / 2, color=C_K, ls=":", lw=0.8)

    # per-bit sampled levels across every rate that was swept
    rates, hi, lo = [], [], []
    for f in sorted(glob.glob(os.path.join(HERE, "tb12_fwd_*.sp.res"))):
        tag = re.search(r"tb12_fwd_(.+)\.sp\.res", os.path.basename(f)).group(1)
        uins = float(tag.replace("p", ".").replace("ns", ""))
        bits = [x for k, x in res_meas(f).items() if re.fullmatch(r"b\d+", k)]
        if not bits:
            continue
        ones = [x for x in bits if x > VH / 2]
        zeros = [x for x in bits if x <= VH / 2]
        rates.append(1e3 / uins)          # Mb/s
        hi.append(min(ones) if ones else np.nan)
        lo.append(max(zeros) if zeros else np.nan)
    order = np.argsort(rates)
    rates = np.array(rates)[order]
    hi = np.array(hi)[order]
    lo = np.array(lo)[order]

    ax2.plot(rates, hi, "o-", color=C_B, lw=1.4, ms=4, label="worst sampled '1'")
    ax2.plot(rates, lo, "s-", color=C_A, lw=1.4, ms=4, label="worst sampled '0'")
    ax2.axhline(0.9 * VH, color=C_B, ls=":", lw=0.9)
    ax2.axhline(0.1 * VH, color=C_A, ls=":", lw=0.9)
    ax2.text(rates.max(), 0.9 * VH + 0.06, "90 % $V_{DDH}$", ha="right",
             fontsize=7, color=C_B)
    ax2.text(rates.max(), 0.1 * VH + 0.06, "10 % $V_{DDH}$", ha="right",
             fontsize=7, color=C_A)
    ax2.set_xlabel("data rate (Mb/s)")
    ax2.set_ylabel("mid-eye sampled level (V)")
    ax2.set_title("Forward level margin vs data rate")
    ax2.set_ylim(-0.2, 3.7)
    ax2.legend(loc="center left")
    save(fig, "08_eye_and_rate_margin.png", FOOT)


# ------------------------------------------------------------- figure 09 ---
def fig_pvt():
    rows = {}
    for f in glob.glob(os.path.join(HERE, "pvt_*.res")):
        mm = re.match(r"pvt_(fwd|rev)_(\w\w)_(-?\d+)C_(\d+)\.sp\.res",
                      os.path.basename(f))
        if not mm:
            continue
        rows[(mm.group(1), mm.group(2), int(mm.group(3)),
              int(mm.group(4)))] = res_meas(f)

    corners = ["ss", "sf", "tt", "fs", "ff"]
    pvts = [(-40, 110, "-40 °C, +10 %", "#56B4E9"),
            (27, 100, "27 °C, nom", "#0072B2"),
            (125, 90, "125 °C, -10 %", "#D55E00")]

    fig, axes = plt.subplots(1, 2, figsize=(9.0, 3.9), sharey=True)
    worst = 0
    for ax, d, title in ((axes[0], "fwd", "Forward  A (1.2 V) → B (3.3 V)"),
                         (axes[1], "rev", "Reverse  B (3.3 V) → A (1.2 V)")):
        w = 0.26
        for j, (T, S, lab, col) in enumerate(pvts):
            lh, hl, xs = [], [], []
            for i, c in enumerate(corners):
                r = rows.get((d, c, T, S))
                if not r:
                    continue
                xs.append(i)
                lh.append(r["tpdlh"] * 1e9)
                hl.append(r["tpdhl"] * 1e9)
            xs = np.array(xs, float) + (j - 1) * w
            ax.bar(xs, lh, w * 0.46, color=col, label=lab if ax is axes[0] else None)
            ax.bar(xs + w * 0.48, hl, w * 0.46, color=col, alpha=0.55)
            worst = max([worst] + lh + hl)
        ax.set_xticks(range(len(corners)), [c.upper() for c in corners])
        ax.set_xlabel("process corner")
        ax.set_title(title)
    axes[0].set_ylabel("propagation delay (ns)")
    axes[0].set_ylim(0, worst * 1.34)
    axes[0].legend(loc="upper right", title="temperature / supply",
                   title_fontsize=8)
    axes[0].axhline(worst, color=C_K, ls="--", lw=0.8)
    axes[1].axhline(worst, color=C_K, ls="--", lw=0.8)
    axes[1].text(len(corners) - 0.5, worst * 1.03,
                 f"worst case {worst:.2f} ns", ha="right", fontsize=8)
    fig.suptitle("Propagation delay across 15 PVT corners  "
                 "(solid = $t_{pdLH}$, faded = $t_{pdHL}$)",
                 y=1.03, fontsize=10, fontweight="bold")
    save(fig, "09_pvt_corners.png", FOOT)


# ------------------------------------------------------------- figure 10 ---
def fig_ring():
    v, m = run("tb6b_ringdiv.sp")
    t = v["time"] * 1e9
    fig, (ax, ax2) = plt.subplots(2, 1, figsize=(7.6, 4.6))
    fig.subplots_adjust(hspace=0.55)
    # top: a few ring cycles, so individual edges stay visible
    ax.plot(t, v["v(xch.z_l)"], color=C_A, lw=1.2)
    ax.set_ylabel("z_l (V)")
    ax.set_xlabel("time (ns)  —  zoomed to 8 ring periods")
    ax.set_xlim(300, 325)
    ax.set_title("Test mode (tm = 1) — internal ring oscillator and ÷16 monitor")
    ax2.plot(t, v["v(ring_div)"], color=C_C, lw=1.3)
    ax2.set_ylabel("ring_div (V)")
    ax2.set_xlabel("time (ns)  —  divided output, full window")
    ax2.set_xlim(200, 600)

    bits = []
    if "fring" in m:
        bits.append(f"ring $f_{{osc}}$ = {m['fring']/1e6:.1f} MHz")
    if "tring" in m:
        bits.append(f"$T_{{ring}}$ = {m['tring']*1e9:.2f} ns")
    if "divratio" in m:
        bits.append(f"divide ratio = {m['divratio']:.2f}  (target 16)")
    if bits:
        ax2.text(0.015, 0.30, "   ".join(bits), transform=ax2.transAxes,
                 fontsize=8, bbox=dict(boxstyle="round,pad=0.35", fc="#f5f5f5",
                                       ec="#cccccc"))
    save(fig, "10_testmode_ring_div16.png", FOOT)


FIGURES = {
    "forward": fig_forward,
    "reverse": fig_reverse,
    "dirflip": fig_dirflip,
    "truthtable": fig_truthtable,
    "leakage": fig_leakage,
    "schmitt": fig_schmitt,
    "dc": fig_dc_transfer,
    "eye": fig_eye,
    "pvt": fig_pvt,
    "ring": fig_ring,
}

if __name__ == "__main__":
    want = sys.argv[1:] or list(FIGURES)
    for name in want:
        print(f"[{name}]")
        try:
            FIGURES[name]()
        except Exception as exc:            # keep going, report at the end
            print(f"  !! {name} failed: {exc}")
    print(f"\nPNGs in {OUT}")
