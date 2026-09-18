// ============================================================================
//  ДИСК (planter/platter) — 170 мм, только под 7" пластинки
//
//  Снизу выбран, оставлены обод и спицы: меньше пластика и меньше
//  поводки при печати. Сверху утопление под мат (войлок или резина).
//  Сидит на валу на ступице со стопорным винтом.
//
//  Печать: перевернуть — рабочей плоскостью на стол. Тогда она получается
//  ровной и гладкой, а спицы и обод печатаются вверх без поддержек.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

assert(platter_hub_h <= platter_h, "Ступица диска выше самого диска");

module platter() {
    dish_h = platter_h - platter_top_t;     // глубина выборки снизу
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
        // отверстие под вал
        thru(spindle_d + 0.3, platter_h);
        // утопление под мат
        translate([0, 0, platter_h - platter_mat_recess])
            cylinder(d = platter_mat_d, h = platter_mat_recess + eps);
        // Стопорный винт в ступице и технологическое отверстие в ободе:
        // без него винт не затянуть, когда диск уже надет на вал.
        // Азимут 30 град — между спицами, чтобы путь был свободен.
        translate([0, 0, platter_hub_h/2])
        rotate([0, 0, 180/platter_spokes]) rotate([0, 90, 0]) {
            cylinder(d = scr3_pilot, h = platter_hub_d);
            translate([0, 0, platter_d/2 - platter_rim_t - eps])
                cylinder(d = set_access_d, h = platter_rim_t + 2*eps);
        }
    }
}

platter();
