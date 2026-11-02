#!/usr/bin/env python3
"""Flat 2D layout plot of the top-level GDS, using the colour schemes in render_gds.py.

Usage (from repo root):
  python3 layout/renders/plot_2d.py [gds] [cell] [--palette slate] [--width 4800]
Writes layout/renders/<palette>/07_layout_2d.png (or 08_<cell>_2d.png for a sub-cell,
e.g. `gds/slot_1.gds bidir_channel`). Needs gdstk and Pillow.
"""
import argparse
import json
import os

from PIL import Image, ImageDraw

from render_gds import HERE, PALETTES, REPO, STACK, VIA, export

ALPHA = {"well": 0.30, "diel": 0.55, "metal": 0.50, "via": 0.90}
SS = 2  # supersampling factor for antialiasing


def to_srgb(rgb):  # palettes are Blender linear colours
    f = lambda c: 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055
    return tuple(round(255 * f(c)) for c in rgb)


def plot(data, palette, width, out_png):
    pal = PALETTES[palette]
    (x0, y0), (x1, y1) = data["bbox"]
    margin = 0.04 * (x1 - x0)
    W = width * SS
    s = W / (x1 - x0 + 2 * margin)
    H = round((y1 - y0 + 2 * margin) * s)
    xy = lambda p: ((p[0] - x0 + margin) * s, H - (p[1] - y0 + margin) * s)

    img = Image.new("RGBA", (W, H), (*to_srgb(pal["bg"]), 255))
    ImageDraw.Draw(img).rectangle([xy((x0, y1)), xy((x1, y0))], fill=(*to_srgb(pal["substrate"]), 255))
    for layer, name, _, _, rgb, kind in STACK:
        polys = data["layers"].get(str(layer), [])
        if not polys:
            continue
        rgb = to_srgb(pal["layers"].get(name, pal.get("via", VIA) if kind == "via" else rgb))
        edge = tuple(min(255, int(c * 1.15)) for c in rgb)
        a = round(255 * ALPHA[kind])
        top = Image.new("RGBA", img.size, (0, 0, 0, 0))
        d = ImageDraw.Draw(top)
        for pts in polys:
            d.polygon([xy(p) for p in pts], fill=(*rgb, a), outline=(*edge, 255), width=SS)
        img.alpha_composite(top)
        print(f"{name}: {len(polys)} polygons")
    img.convert("RGB").resize((W // SS, H // SS), Image.LANCZOS).save(out_png)
    print("wrote", out_png)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("gds", nargs="?", default=os.path.join(REPO, "gds", "slot_1.gds"))
    ap.add_argument("cell", nargs="?", default="slot_1")
    ap.add_argument("--palette", default="slate", choices=list(PALETTES))
    ap.add_argument("--width", type=int, default=4800, help="output width in pixels")
    a = ap.parse_args()
    out_json = os.path.join(os.environ.get("TMPDIR", "/tmp"), a.cell + "_layers.json")
    export(a.gds, a.cell, out_json)
    with open(out_json) as f:
        data = json.load(f)
    os.makedirs(os.path.join(HERE, a.palette), exist_ok=True)
    name = "07_layout_2d.png" if a.cell == "slot_1" else f"08_{a.cell}_2d.png"
    plot(data, a.palette, a.width, os.path.join(HERE, a.palette, name))
