// ============================================================================
//  ПОДСТАВКА ТОНАРМА
//
//  Стойка с U-образным ложем: трубка в нерабочем положении ложится в паз
//  со стенками до её верха, так что при переноске вбок ей деться некуда.
//
//  Приподнимает трубку на arm_rest_lift, чтобы игла гарантированно не
//  касалась ни пластинки, ни крышки. Крепится двумя саморезами изнутри
//  корпуса, как и стойка тонарма.
//
//  Печать: как есть, основанием на стол, без поддержек — переход от ствола
//  к голове положе 45 град.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module tonearm_rest() {
    boss_h = 6;
    tz  = arm_rest_tube_z - case_h;     // высоты ниже — от верха крышки
    top = arm_rest_top_z - case_h;
    hb  = arm_rest_head_bot - case_h;
    tr  = 8;                            // высота перехода ствол → голова

    module head_profile() rrect(arm_rest_head_len, 2*arm_rest_head_hw, 2);

    translate([arm_rest_pos[0], arm_rest_pos[1], case_h])
        rotate([0, 0, arm_park_azimuth]) difference() {
            union() {
                chamfered_cyl(arm_rest_foot_d, arm_rest_foot_t, ch = 1, bottom = false);
                translate([0, 0, arm_rest_foot_t - eps])
                    cylinder(d1 = arm_rest_od + 8, d2 = arm_rest_od, h = 8);
                cylinder(d = arm_rest_od, h = hb - tr + eps);
                // переход от ствола к голове
                hull() {
                    translate([0, 0, hb - tr]) cylinder(d = arm_rest_od, h = eps);
                    translate([0, 0, hb]) linear_extrude(height = eps) head_profile();
                }
                // голова с ложем
                translate([0, 0, hb]) linear_extrude(height = top - hb) head_profile();
                // бобышки крепёжных саморезов
                for (s = [-1, 1])
                    translate([0, s*arm_rest_scr_dx, 0])
                        cylinder(d = scr25_boss_d, h = arm_rest_foot_t + boss_h);
            }
            // ложе: полукруглое дно и прямые стенки до верха головы. Центр дна
            // поднят на зазор, чтобы ось уложенной трубки была ровно на tz.
            translate([0, 0, tz + arm_rest_clr]) rotate([0, 90, 0])
                cylinder(d = arm_rest_chan_w, h = arm_rest_head_len + 2, center = true);
            translate([-arm_rest_head_len/2 - 1, -arm_rest_chan_w/2, tz + arm_rest_clr])
                cube([arm_rest_head_len + 2, arm_rest_chan_w, top - tz + 1]);
            // пилотные отверстия (саморезы вкручиваются снизу)
            for (s = [-1, 1])
                translate([0, s*arm_rest_scr_dx, -eps])
                    cylinder(d = scr25_pilot, h = arm_rest_foot_t + boss_h);
        }
}

tonearm_rest();
