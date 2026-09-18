// ============================================================================
//  КОЛЕСО НА ВАЛУ (ведомый шкив пассика)
//
//  Сидит на валу сразу над втулкой — так плечо изгиба от натяжения пассика
//  минимально. Канавка под круглый пассик, крепление стопорным винтом.
//
//  Печать: как есть, плашмя. Соотношение с ведущим шкивом задаётся
//  параметрами pulley_d / motor_pulley_d (см. сводку в echo).
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module pulley() {
    web_d = pulley_d - 2*pulley_rim_t;
    translate([platter_pos[0], platter_pos[1], pulley_z]) difference() {
        union() {
            tube(pulley_d, web_d, pulley_h);                  // обод
            cylinder(d = web_d + eps, h = pulley_web_t);      // диск
            chamfered_cyl(pulley_hub_d, pulley_hub_h, ch = 0.5, bottom = false);
        }
        // канавка под пассик
        translate([0, 0, pulley_h/2]) belt_groove(pulley_d, belt_groove_r);
        // посадка на вал
        thru(spindle_d + 0.3, pulley_h);
        // облегчение
        radial_holes(5, (web_d/2 + pulley_hub_d/2)/2, 14, pulley_web_t);
        // Стопорный винт и технологическое отверстие в ободе (иначе к винту
        // не подлезть отвёрткой). Азимут — между облегчающими отверстиями.
        translate([0, 0, pulley_hub_h/2]) rotate([0, 0, 36]) rotate([0, 90, 0]) {
            cylinder(d = scr3_pilot, h = pulley_hub_d);
            translate([0, 0, web_d/2 - eps])
                cylinder(d = set_access_d, h = pulley_rim_t + 2*eps);
        }
    }
}

pulley();
