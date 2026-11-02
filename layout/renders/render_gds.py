#!/usr/bin/env python3
"""Render 3D Blender images of the top-level GDS (gds/slot_1.gds, cell slot_1).

Two stages, both driven from this one file:
  1. system python (needs gdstk): flatten + merge each drawing layer, dump JSON
  2. blender -b -P this_file -- <json> <outdir>: extrude layers, render views

Usage (from repo root):
  python3 layout/renders/render_gds.py [gds] [cell] [--palette original|copper|neon|ocean|all]
Images land in layout/renders/<palette>/.
"""
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))

# IHP SG13 (sg13cmos5l) back-end stack, approximate, in um: (gds layer, name, z0, z1, colour, kind)
STACK = [
    (31, "NWell",     -0.40, 0.00, (0.55, 0.45, 0.20), "well"),
    (1,  "Activ",      0.00, 0.10, (0.15, 0.55, 0.20), "diel"),
    (5,  "GatPoly",    0.10, 0.26, (0.80, 0.12, 0.10), "diel"),
    (6,  "Cont",       0.10, 0.64, (0.75, 0.75, 0.78), "via"),
    (8,  "Metal1",     0.64, 1.06, (0.20, 0.45, 0.90), "metal"),
    (19, "Via1",       1.06, 1.60, (0.75, 0.75, 0.78), "via"),
    (10, "Metal2",     1.60, 2.09, (0.85, 0.25, 0.65), "metal"),
    (29, "Via2",       2.09, 2.63, (0.75, 0.75, 0.78), "via"),
    (30, "Metal3",     2.63, 3.12, (0.95, 0.65, 0.15), "metal"),
    (49, "Via3",       3.12, 3.66, (0.75, 0.75, 0.78), "via"),
    (50, "Metal4",     3.66, 4.15, (0.20, 0.75, 0.70), "metal"),
    (125, "TopVia1",   4.15, 5.00, (0.75, 0.75, 0.78), "via"),
    (126, "TopMetal1", 5.00, 7.00, (0.95, 0.75, 0.35), "metal"),
]
Z_SCALE = 2.0  # vertical exaggeration so thin layers read at die scale

# alternative colour schemes: per-layer colour overrides, substrate, background, metal metallic-ness
VIA = (0.75, 0.75, 0.78)
PALETTES = {
    "original": {"layers": {}, "substrate": (0.05, 0.05, 0.06), "bg": (0.02, 0.022, 0.03), "metallic": 0.85},
    "copper": {  # roughly what the real back end looks like: Cu/Al metals, W vias, dark silicon
        "layers": {"NWell": (0.12, 0.10, 0.14), "Activ": (0.22, 0.30, 0.20), "GatPoly": (0.45, 0.12, 0.10),
                   "Cont": (0.55, 0.55, 0.60), "Metal1": (0.95, 0.52, 0.33), "Metal2": (0.92, 0.45, 0.30),
                   "Metal3": (0.85, 0.55, 0.30), "Metal4": (0.90, 0.62, 0.38), "TopVia1": (0.80, 0.80, 0.82),
                   "TopMetal1": (0.91, 0.92, 0.93)},
        "via": (0.55, 0.55, 0.60), "substrate": (0.03, 0.03, 0.035), "bg": (0.005, 0.005, 0.008), "metallic": 1.0},
    "neon": {  # saturated hue ramp up the stack on near-black
        "layers": {"NWell": (0.10, 0.02, 0.15), "Activ": (0.0, 0.9, 0.4), "GatPoly": (1.0, 0.05, 0.10),
                   "Metal1": (0.05, 0.45, 1.0), "Metal2": (0.55, 0.15, 1.0), "Metal3": (1.0, 0.10, 0.55),
                   "Metal4": (1.0, 0.45, 0.02), "TopMetal1": (1.0, 0.85, 0.15)},
        "via": (0.95, 0.95, 1.0), "substrate": (0.01, 0.01, 0.015), "bg": (0.0, 0.0, 0.002), "metallic": 0.3},
    "ocean": {  # cool monochrome-ish ramp, deep teal at the bottom to pale ice on top
        "layers": {"NWell": (0.02, 0.08, 0.10), "Activ": (0.05, 0.30, 0.30), "GatPoly": (0.95, 0.45, 0.25),
                   "Metal1": (0.03, 0.35, 0.55), "Metal2": (0.05, 0.55, 0.70), "Metal3": (0.20, 0.72, 0.80),
                   "Metal4": (0.50, 0.85, 0.88), "TopMetal1": (0.85, 0.95, 0.97)},
        "via": (0.95, 0.75, 0.40), "substrate": (0.01, 0.03, 0.05), "bg": (0.004, 0.012, 0.02), "metallic": 0.6},
    "slate": {  # studio portrait: slate-blue backdrop, charcoal, houndstooth taupe, tortoise, rose, silver
        "layers": {"NWell": (0.042, 0.030, 0.023), "Activ": (0.212, 0.178, 0.156), "GatPoly": (0.584, 0.223, 0.205),
                   "Metal1": (0.246, 0.133, 0.074), "Metal2": (0.658, 0.371, 0.305), "Metal3": (0.624, 0.546, 0.456),
                   "Metal4": (0.584, 0.223, 0.205), "TopMetal1": (0.839, 0.776, 0.701)},
        "via": (0.631, 0.644, 0.672), "substrate": (0.027, 0.027, 0.027), "bg": (0.301, 0.342, 0.386),
        "bg_strength": 0.5, "metallic": 0.55},
}


def export(gds, cell, out_json):
    import gdstk
    lib = gdstk.read_gds(gds)
    top = lib[cell].copy(cell + "_flat").flatten()
    by_layer = {}
    for p in top.polygons:
        if p.datatype == 0:
            by_layer.setdefault(p.layer, []).append(p)
    data = {"bbox": [list(v) for v in lib[cell].bounding_box()], "layers": {}}
    for layer, *_ in STACK:
        merged = gdstk.boolean(by_layer.get(layer, []), [], "or", precision=1e-4)
        data["layers"][str(layer)] = [p.points.round(4).tolist() for p in merged]
        print(f"layer {layer}: {len(by_layer.get(layer, []))} -> {len(merged)} polygons")
    with open(out_json, "w") as f:
        json.dump(data, f)


# ---------------------------------------------------------------- blender side
def blender_main(json_path, outdir, palette="original"):
    import bpy
    from mathutils import Vector
    from mathutils.geometry import tessellate_polygon

    with open(json_path) as f:
        data = json.load(f)
    (x0, y0), (x1, y1) = data["bbox"]
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    W, H = x1 - x0, y1 - y0

    bpy.ops.wm.read_factory_settings(use_empty=True)
    pal = PALETTES[palette]
    os.makedirs(outdir, exist_ok=True)
    scene = bpy.context.scene

    def material(name, rgb, kind):
        m = bpy.data.materials.new(name)
        m.use_nodes = True
        b = m.node_tree.nodes["Principled BSDF"]
        b.inputs["Base Color"].default_value = (*rgb, 1)
        if kind == "metal":
            b.inputs["Metallic"].default_value = pal["metallic"]
            b.inputs["Roughness"].default_value = 0.28
        elif kind == "via":
            b.inputs["Metallic"].default_value = 1.0
            b.inputs["Roughness"].default_value = 0.35
        elif kind == "well":
            b.inputs["Roughness"].default_value = 0.8
            b.inputs["Alpha"].default_value = 0.35
        else:
            b.inputs["Roughness"].default_value = 0.5
        return m

    def extrude(name, polys, z0, z1):
        verts, faces = [], []
        for pts in polys:
            n = len(pts)
            if n < 3:
                continue
            base = len(verts)
            verts += [(x - cx, y - cy, z0) for x, y in pts]
            verts += [(x - cx, y - cy, z1) for x, y in pts]
            for tri in tessellate_polygon([[Vector((x, y, 0)) for x, y in pts]]):
                a, b, c = tri
                faces.append((base + a, base + c, base + b))
                faces.append((base + n + a, base + n + b, base + n + c))
            for i in range(n):
                j = (i + 1) % n
                faces.append((base + i, base + j, base + n + j, base + n + i))
        me = bpy.data.meshes.new(name)
        me.from_pydata(verts, [], faces)
        me.validate()
        me.update()
        ob = bpy.data.objects.new(name, me)
        scene.collection.objects.link(ob)
        return ob

    objs = []
    for layer, name, z0, z1, rgb, kind in STACK:
        polys = data["layers"].get(str(layer), [])
        if not polys:
            continue
        ob = extrude(name, polys, z0 * Z_SCALE, z1 * Z_SCALE)
        rgb = pal["layers"].get(name, pal.get("via", VIA) if kind == "via" else rgb)
        ob.data.materials.append(material(name, rgb, kind))
        objs.append(ob)

    # substrate slab
    sub = extrude("Substrate", [[(x0 - 4, y0 - 4), (x1 + 4, y0 - 4), (x1 + 4, y1 + 4), (x0 - 4, y1 + 4)]],
                  -3.0, -0.41 * Z_SCALE)
    sub.data.materials.append(material("Substrate", pal["substrate"], "diel"))

    # world + lights
    world = bpy.data.worlds.new("World")
    world.use_nodes = True
    world.node_tree.nodes["Background"].inputs["Color"].default_value = (*pal["bg"], 1)
    world.node_tree.nodes["Background"].inputs["Strength"].default_value = pal.get("bg_strength", 1.0)
    scene.world = world
    sun = bpy.data.objects.new("Sun", bpy.data.lights.new("Sun", "SUN"))
    sun.data.energy = 2.0
    sun.data.angle = 0.15
    sun.rotation_euler = (0.75, 0.25, 0.9)
    scene.collection.objects.link(sun)
    fill = bpy.data.objects.new("Fill", bpy.data.lights.new("Fill", "SUN"))
    fill.data.energy = 1.0
    fill.rotation_euler = (1.0, -0.4, -2.3)
    scene.collection.objects.link(fill)

    # cycles on the GPU when available
    scene.render.engine = "CYCLES"
    try:
        prefs = bpy.context.preferences.addons["cycles"].preferences
        prefs.compute_device_type = "METAL"
        prefs.get_devices()
        for d in prefs.devices:
            d.use = True
        scene.cycles.device = "GPU"
    except Exception as e:
        print("GPU setup failed, using CPU:", e)
    scene.cycles.samples = 96
    scene.cycles.use_denoising = True
    scene.render.film_transparent = False
    scene.view_settings.view_transform = "AgX"
    scene.render.image_settings.file_format = "PNG"

    cam = bpy.data.objects.new("Cam", bpy.data.cameras.new("Cam"))
    scene.collection.objects.link(cam)
    scene.camera = cam

    def look(loc, target):
        cam.location = Vector(loc)
        d = Vector(target) - cam.location
        cam.rotation_euler = d.to_track_quat("-Z", "Y").to_euler()

    def shot(fname, res, loc, target, ortho=None, lens=50):
        scene.render.resolution_x, scene.render.resolution_y = res
        if ortho:
            cam.data.type = "ORTHO"
            cam.data.ortho_scale = ortho
        else:
            cam.data.type = "PERSP"
            cam.data.lens = lens
        cam.data.clip_end = 10000
        look(loc, target)
        scene.render.filepath = os.path.join(outdir, fname)
        bpy.ops.render.render(write_still=True)
        print("wrote", scene.render.filepath)

    # densest spot (by contact count in a 40 um window) for the close-ups
    cont = data["layers"].get("6", [])
    best, spot = -1, (0.0, 0.0)
    pts = [(sum(p[0] for p in poly) / len(poly), sum(p[1] for p in poly) / len(poly)) for poly in cont]
    for gx in range(int(x0) + 20, int(x1) - 20, 10):
        for gy in range(int(y0) + 20, int(y1) - 20, 10):
            n = sum(1 for x, y in pts if abs(x - gx) < 20 and abs(y - gy) < 20)
            if n > best:
                best, spot = n, (gx - cx, gy - cy)
    sx, sy = spot

    shot("01_iso_overview.png", (2400, 1350), (W * 0.55, -W * 0.75, W * 0.6), (0, 0, 0), ortho=W * 1.12)
    shot("02_top_down.png", (2400, int(2400 * H / W) + 40), (0, 0, 500), (0, 0, 0), ortho=W * 1.04)
    shot("03_low_angle.png", (2400, 1350), (-W * 0.42, -H * 0.85, H * 0.22), (-W * 0.05, H * 0.05, 0), lens=30)
    shot("04_closeup.png", (2400, 1600), (sx + 32, sy - 42, 34), (sx, sy, 2), lens=40)
    shot("05_closeup_detail.png", (2400, 1600), (sx - 18, sy - 26, 18), (sx + 2, sy + 2, 1), lens=35)

    # exploded stack: spread layers apart vertically
    for i, ob in enumerate(objs):
        ob.location.z = i * 7.0
    sub.hide_render = True
    shot("06_exploded.png", (2400, 1600), (sx + 75, sy - 95, 115), (sx, sy, len(objs) * 3.5), lens=45)


if __name__ == "__main__":
    if "--" in sys.argv:  # running inside blender
        args = sys.argv[sys.argv.index("--") + 1:]
        blender_main(*args)
    else:
        import argparse
        ap = argparse.ArgumentParser()
        ap.add_argument("gds", nargs="?", default=os.path.join(REPO, "gds", "slot_1.gds"))
        ap.add_argument("cell", nargs="?", default="slot_1")
        ap.add_argument("--palette", default="all", help="one of %s, or all" % ", ".join(PALETTES))
        a = ap.parse_args()
        gds, cell = a.gds, a.cell
        out_json = os.path.join(os.environ.get("TMPDIR", "/tmp"), cell + "_layers.json")
        export(gds, cell, out_json)
        blender = os.environ.get("BLENDER", "blender")
        for pal in (PALETTES if a.palette == "all" else [a.palette]):
            subprocess.run([blender, "-b", "--factory-startup", "-P", os.path.abspath(__file__), "--",
                            out_json, os.path.join(HERE, pal), pal], check=True)
