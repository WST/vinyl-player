// ============================================================================
//  СТОЙКА ТОНАРМА (неподвижная опора вертикальной оси)
//
//  Крепится к крышке тремя саморезами ИЗНУТРИ корпуса (шляпки снизу),
//  поэтому снаружи нет ни одного видимого винта. Внутри — канал
//  вертикального подшипника с двумя рабочими поясками и карманом для
//  смазки, ниже — проход сигнального провода внутрь корпуса.
//
//  Печать: как есть, фланцем на стол — канал печатается вертикально.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module tonearm_base() {
    bore_d = arm_pivot_shaft_d + arm_pivot_clr;
    h_tot  = arm_base_flange_t + arm_pillar_h;      // полная высота детали
    bore_bottom = h_tot - arm_pivot_shaft_len - 0.5; // упорный поясок (пятка)
    translate([arm_pivot_pos[0], arm_pivot_pos[1], case_h]) difference() {
        union() {
            chamfered_cyl(arm_base_flange_d, arm_base_flange_t, ch = 1,
                          bottom = false);
            // конусный переход и сама стойка
            translate([0, 0, arm_base_flange_t - eps])
                cylinder(d1 = arm_pillar_od + 12, d2 = arm_pillar_od, h = 10);
            cylinder(d = arm_pillar_od, h = h_tot);
            // бобышки крепёжных саморезов с косынками
            for (a = [90, 210, 330]) rotate([0, 0, a]) {
                translate([arm_base_scr_r, 0, 0])
                    cylinder(d = scr25_boss_d, h = arm_base_flange_t + arm_base_boss_h);
                translate([arm_pillar_od/2 - 0.5, 0, arm_base_flange_t])
                    gusset(arm_base_scr_r - arm_pillar_od/2 + 3, 8, 3);
            }
        }
        // канал вертикального подшипника: два пояска + карман для смазки
        translate([0, 0, bore_bottom]) cylinder(d = bore_d, h = h_tot);
        translate([0, 0, bore_bottom + arm_pivot_land])
            cylinder(d = bore_d + bush_relief_extra,
                     h = arm_pivot_shaft_len - 2*arm_pivot_land);
        translate([0, 0, h_tot - 1])
            cylinder(d1 = bore_d, d2 = bore_d + 2, h = 1 + eps);
        // проход сигнального провода
        thru(arm_pivot_wire_d, h_tot);
        // пилотные отверстия под саморезы (вкручиваются снизу)
        for (a = [90, 210, 330]) rotate([0, 0, a])
            translate([arm_base_scr_r, 0, -eps])
                cylinder(d = scr25_pilot, h = arm_base_flange_t + arm_base_boss_h);
    }
}

tonearm_base();
