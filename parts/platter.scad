// ============================================================================
//  ДИСК (planter/platter) — 170 мм, только под 7" пластинки
//
//  Снизу выбран, оставлены обод и спицы: меньше пластика и меньше
//  поводки при печати. Сверху утопление под печатный мат из TPU.
//  На вал не винтится: отверстие под кончик 7.1, ступица садится на
//  уступ 8→7.1 и снимается вверх. Посадку правит platter_bore_clr.
//
//  Печать: перевернуть — рабочей плоскостью на стол. Тогда она получается
//  ровной и гладкой, а спицы и обод печатаются вверх без поддержек.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

assert(platter_hub_h <= platter_h, "Ступица диска выше самого диска");

module platter() {
    dish_h = platter_h - platter_top_t;     // глубина выборки снизу
    bore_d = spindle_tip_d + platter_bore_clr;
    translate([platter_pos[0], platter_pos[1], platter_bottom_z]) difference() {
        union() {
            // обод + рабочая плоскость
            difference() {
                chamfered_cyl(platter_d, platter_h, ch = 0.8);
                translate([0, 0, -eps])
                    cylinder(d = platter_d - 2*platter_rim_t, h = dish_h + eps);
            }
            // ступица
            chamfered_cyl(platter_hub_d, platter_hub_h, ch = 0.5, bottom = false);
            // спицы
            for (i = [0 : platter_spokes - 1])
                rotate([0, 0, i*360/platter_spokes])
                    translate([0, -1.25, 0])
                        cube([platter_d/2 - platter_rim_t + eps, 2.5, dish_h]);
        }
        thru(bore_d, platter_h);
        // заход на уступ вала
        translate([0, 0, -eps])
            cylinder(d1 = bore_d + 1.2, d2 = bore_d, h = 0.8);
        // утопление под мат
        translate([0, 0, platter_h - platter_mat_recess])
            cylinder(d = platter_mat_d, h = platter_mat_recess + eps);
    }
}

platter();
