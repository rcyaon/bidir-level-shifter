import pya
ly=pya.Layout(); ly.read("../gds/slot_1.gds"); t=ly.cell("slot_1")
print("bbox", t.dbbox())
for li in ly.layer_indexes():
    info=ly.get_info(li); r=pya.Region(t.begin_shapes_rec(li))
    if not r.is_empty(): print(info, r.bbox().to_dtype(ly.dbu))
