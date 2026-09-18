// ============================================================================
//  ВТУЛКА УЗЛА ВРАЩЕНИЯ
//
//  Запрессовывается (и подклеивается) в стакан поддона, фланцем на дно.
//  Внутри: два рабочих пояска сверху и снизу, между ними расточка —
//  карман для смазки. Дно закрыто: торец вала опирается на «пятку».
//
//  Печать: как есть, фланцем на стол. Канал печатается вертикально,
//  поэтому получается достаточно круглым. Перед сборкой прогнать канал
//  сверлом/развёрткой 7.3 и заложить густую смазку (ЦИАТИМ/литол).
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module bushing() {
    bore_d   = spindle_d + spindle_clr;
    relief_d = bore_d + bush_relief_extra;
    translate([platter_pos[0], platter_pos[1], bush_z]) difference() {
        union() {
            chamfered_cyl(bush_flange_d, bush_flange_t, ch = 0.6, bottom = false);
            chamfered_cyl(bush_od, bush_h, ch = 0.8, bottom = false);
        }
        // рабочий канал
        translate([0, 0, bush_thrust_t]) cylinder(d = bore_d, h = bush_h);
        // карман для смазки между поясками
        translate([0, 0, bush_thrust_t + bush_land])
            cylinder(d = relief_d, h = bush_h - bush_thrust_t - 2*bush_land);
        // заходная фаска канала
        translate([0, 0, bush_h - 1])
            cylinder(d1 = bore_d, d2 = bore_d + 2, h = 1 + eps);
    }
}

bushing();
