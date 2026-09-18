// ============================================================================
//  ВЕДУЩИЙ ШКИВ (на валу двигателя)
//
//  ВНИМАНИЕ: двигатель ещё не выбран, поэтому диаметр вала
//  (motor_shaft_d) и передаточное отношение — предварительные.
//  Печать: стоя, 100% заполнение. Посадка на вал — с натягом + фиксатор.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module motor_pulley() {
    translate([motor_pos[0], motor_pos[1], pulley_z]) difference() {
        chamfered_cyl(motor_pulley_d, pulley_h, ch = 0.4);
        thru(motor_shaft_d + 0.05, pulley_h);
        translate([0, 0, pulley_h/2]) belt_groove(motor_pulley_d, belt_groove_r);
        // радиальный винт М2 для фиксации на валу
        translate([0, 0, 2]) rotate([0, 90, 0])
            cylinder(d = 1.8, h = motor_pulley_d);
    }
}

motor_pulley();
