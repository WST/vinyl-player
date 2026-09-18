// ============================================================================
//  ХОМУТ ДВИГАТЕЛЯ
//
//  Двигатель стоит валом вверх прямо на дне поддона, а этот хомут держит
//  его за корпус. Лапы с пазами позволяют подвинуть двигатель по линии
//  «двигатель — ось диска» и натянуть пассик; сам двигатель можно
//  подвинуть по высоте, ослабив стяжной винт.
//
//  ВНИМАНИЕ: размеры под двигатель предварительные (motor_body_d/h) —
//  двигатель пока не выбран. Меняется одним параметром.
//
//  Печать: как есть, плашмя (лапы и нижний торец хомута в одной плоскости).
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module motor_mount() {
    id = motor_body_d + motor_clamp_clr;
    od = id + 2*motor_clamp_t;
    translate([motor_pos[0], motor_pos[1], 0]) rotate([0, 0, motor_dir]) {
        difference() {
            union() {
                // хомут
                translate([0, 0, motor_clamp_z]) tube(od, id, motor_clamp_h);
                // «уши» стяжного винта (по обе стороны прорези)
                for (s = [-1, 1])
                    translate([-(od/2 + motor_ear), s == 1 ? 1 : -5, motor_clamp_z])
                        cube([motor_ear + (od - id)/2, 4, motor_clamp_h]);
                // лапы
                for (s = [-1, 1]) hull() {
                    translate([0, s*motor_foot_span/2, motor_clamp_z])
                        cylinder(d = motor_boss_d + 4, h = motor_foot_t);
                    translate([-7, s*(od/2 - 2), motor_clamp_z])
                        cube([14, 2, motor_foot_t]);
                }
            }
            // прорезь хомута
            translate([-(od/2 + motor_ear + 1), -1, motor_clamp_z - eps])
                cube([od/2 + motor_ear + 1, 2, motor_clamp_h + 2*eps]);
            // стяжной винт 3x16: проходное с одной стороны, пилотное с другой
            translate([-(od/2 + motor_ear/2), 0, motor_clamp_z + motor_clamp_h/2])
                rotate([90, 0, 0]) {
                    cylinder(d = scr3_free, h = 10);
                    translate([0, 0, -10]) cylinder(d = scr3_pilot, h = 10);
                }
            // пазы регулировки натяжения пассика
            for (s = [-1, 1])
                translate([0, s*motor_foot_span/2, motor_clamp_z - eps])
                    slot(motor_slot_len, scr3_free, motor_foot_t + 2*eps);
        }
    }
}

motor_mount();
