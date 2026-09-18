// ============================================================================
//  ПОДСТАВКА ТОНАРМА
//
//  Простая стойка с ложем: на неё тонарм кладётся в нерабочем положении.
//  Приподнимает трубку на arm_rest_lift, чтобы игла гарантированно не
//  касалась ни пластинки, ни крышки. Фиксатора тонарма нет — при
//  необходимости на будущее напечатаем клипсу.
//
//  Крепится двумя саморезами изнутри корпуса, как и стойка тонарма.
//
//  Печать: как есть, основанием на стол.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module tonearm_rest() {
    boss_h = 6;
    translate([arm_rest_pos[0], arm_rest_pos[1], case_h])
        rotate([0, 0, arm_park_azimuth]) difference() {
            union() {
                chamfered_cyl(arm_rest_foot_d, arm_rest_foot_t, ch = 1, bottom = false);
                translate([0, 0, arm_rest_foot_t - eps])
                    cylinder(d1 = arm_rest_od + 8, d2 = arm_rest_od, h = 8);
                cylinder(d = arm_rest_od, h = arm_rest_h);
                // бобышки крепёжных саморезов
                for (s = [-1, 1])
                    translate([0, s*arm_rest_scr_dx, 0])
                        cylinder(d = scr25_boss_d, h = arm_rest_foot_t + boss_h);
            }
            // ложе под трубку: канавка вдоль припаркованной трубки
            translate([0, 0, arm_rest_groove_z - case_h]) rotate([0, 90, 0])
                cylinder(d = arm_rest_notch_w, h = arm_rest_od + 2, center = true);
            // пилотные отверстия (саморезы вкручиваются снизу)
            for (s = [-1, 1])
                translate([0, s*arm_rest_scr_dx, -eps])
                    cylinder(d = scr25_pilot, h = arm_rest_foot_t + boss_h);
        }
}

tonearm_rest();
