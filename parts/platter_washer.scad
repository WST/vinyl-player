// ============================================================================
//  ШАЙБА ПОД ДИСК
//
//  Садится на уступ 8→7.1, диск — на неё. Нужна, потому что диск внатуру
//  ложился на крышку и не крутился. Толщина platter_washer_h; если мало
//  или много — перепечатать только шайбу. Отверстие то же, что у диска
//  (platter_bore_clr), наружный диаметр — как ступица, чтобы не торчала.
//
//  Печать: плашмя, без поддержек.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module platter_washer() {
    bore_d = spindle_tip_d + platter_bore_clr;
    translate([platter_pos[0], platter_pos[1], spindle_tip_z]) difference() {
        chamfered_cyl(platter_hub_d, platter_washer_h, ch = 0.4);
        thru(bore_d, platter_washer_h);
        translate([0, 0, -eps])
            cylinder(d1 = bore_d + 1.2, d2 = bore_d, h = 0.8);
    }
}

platter_washer();
