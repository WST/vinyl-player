// ============================================================================
//  ДЕРЖАТЕЛЬ ДВИГАТЕЛЯ RF-300C-14270
//
//  Стакан с хомутом: двигатель стоит донцем на дне держателя валом вверх,
//  обжимается стяжным винтом 3 x 16. Толщина дна выставляет канавку
//  заводского колеса ровно в плоскость пассика 1 (см. motor_groove_z).
//  Две лапы с пазами вдоль линии «промвал — двигатель»: сдвигом
//  натягивается пассик 1. Крепится к шасси двумя саморезами 2.5 x 8.
//
//  Самая «расходная» деталь модуля: другой двигатель или неточная высота
//  канавки — перепечатывается только она.
//
//  Печать: как есть, дном на стол.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>

module drive_motor_holder() {
    cup_top = holder_base_t + holder_cup_h;
    translate([motor_pos[0], motor_pos[1], holder_z0]) rotate([0, 0, motor_angle])
    difference() {
        union() {
            // основание с лапами
            hull() {
                cylinder(d = holder_cup_od, h = holder_base_t);
                for (s = [-1, 1], dx = [-1, 1])
                    translate([dx*holder_slot_len/2, s*holder_foot_span/2, 0])
                        cylinder(d = holder_boss_d + 4, h = holder_base_t);
            }
            cylinder(d = holder_cup_od, h = cup_top);
            // уши стяжного винта — с внешней стороны, подальше от пассика
            for (s = [-1, 1])
                translate([holder_cup_od/2 - holder_wall, s == 1 ? 1 : -5, 0])
                    cube([holder_wall + holder_ear, 4, cup_top]);
        }
        // гнездо двигателя и выемка под выступ на донце
        translate([0, 0, holder_base_t]) cylinder(d = holder_cup_id, h = cup_top);
        translate([0, 0, holder_base_t - motor_bump_h]) cylinder(d = motor_bump_d, h = motor_bump_h + eps);
        // вырез под провода у донца
        rotate([0, 0, motor_wire_angle])
            translate([holder_cup_id/2 - 1, -5, holder_base_t])
                cube([holder_wall + 2, 10, 5]);
        // прорезь хомута
        translate([0, -1, holder_base_t])
            cube([holder_cup_od/2 + holder_ear + 1, 2, cup_top]);
        // стяжной винт: проходное с одной стороны, пилотное с другой
        translate([holder_cup_od/2 + holder_ear/2, 0, holder_base_t + holder_cup_h/2])
            rotate([90, 0, 0]) {
                cylinder(d = scr3_free, h = 10);
                translate([0, 0, -10]) cylinder(d = scr3_pilot, h = 10);
            }
        // пазы крепления
        for (s = [-1, 1])
            translate([0, s*holder_foot_span/2, -eps])
                slot(holder_slot_len, scr25_free, holder_base_t + 2*eps);
    }
}

drive_motor_holder();
