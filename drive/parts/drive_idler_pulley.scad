// ============================================================================
//  БОЛЬШОЕ КОЛЕСО ПРОМВАЛА (ведомое, первая ступень)
//
//  Диск сверху, ступица уходит вниз и не касается кромки стакана
//  (зазор idler_hub_clr): вал сидит на пятке, колесо не трётся о шасси.
//  На PLA колесо клеится; отверстие под стопорный винт — rod_set_screws.
//  Выше колеса сам вал работает шкивом второй ступени; верх колеса —
//  нижний бортик для пассика 2.
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
            translate([0, 0, idler_hub_z0])
                chamfered_cyl(pulley_hub_d, idler_pulley_z1 - idler_hub_z0, ch = 0.5, top = false);
        }
        translate([0, 0, idler_hub_z0]) thru(spindle_d + rod_bore_clr, idler_pulley_z1 - idler_hub_z0);
        if (rod_set_screws)
            translate([0, 0, idler_hub_z0]) set_screw_hole(idler_set_z - idler_hub_z0);
    }
}

drive_idler_pulley();
