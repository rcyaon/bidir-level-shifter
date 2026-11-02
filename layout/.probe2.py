import pya
ly=pya.Layout(); ly.read("../gds/slot_1.gds"); t=ly.cell("slot_1")
win=pya.Box(60000,188000,535000,273000)
for li in ly.layer_indexes():
    info=ly.get_info(li)
    if info.layer==189: continue
    r=pya.Region(t.begin_shapes_rec_overlapping(li,win))&pya.Region(win)
    if not r.is_empty(): print(info, r.bbox().to_dtype(ly.dbu), r.count())
