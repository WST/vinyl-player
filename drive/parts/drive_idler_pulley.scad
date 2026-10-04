// ============================================================================
//  БОЛЬШОЕ КОЛЕСО ПРОМВАЛА (ведомое, первая ступень)
//
//  Диск сверху, ступица уходит вниз и упирается пояском во внутреннее
//  кольцо верхнего подшипника. Стопорный винт M3 — в ступице под колесом,
//  туда подход сбоку. Выше колеса сам стальной вал работает шкивом
//  второй ступени; верх колеса — нижний бортик для пассика 2.
//
//  Печать: перевернуть — диском на стол, ступица вверх. 100% заполнение
//  ступицы.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>
use <../drive_lib.scad>

module drive_idler_pulley() {
    translate([idler_pos[0], idler_pos[1], 0]) difference() {
        union() {
            translate([0, 0, idler_pulley_z0]) pulley_wheel(idler_pulley_od, web_top = true);
            translate([0, 0, idler_tower_top + thrust_ring_h])
                chamfered_cyl(pulley_hub_d, idler_pulley_z1 - idler_tower_top - thrust_ring_h,
                              ch = 0.5, top = false);
            translate([0, 0, idler_tower_top])
                cylinder(d = brg_inner_ring_d, h = thrust_ring_h + eps);
        }
        translate([0, 0, idler_tower_top]) thru(spindle_d + rod_bore_clr, idler_pulley_z1 - idler_tower_top);
        translate([0, 0, idler_tower_top]) set_screw_hole(idler_set_z - idler_tower_top);
    }
}

drive_idler_pulley();
