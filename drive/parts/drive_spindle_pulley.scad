// ============================================================================
//  КОЛЕСО ВАЛА ДИСКА (ведомое, вторая ступень)
//
//  Сидит на валу над верхним подшипником через шайбу drive_spacer и держит
//  вал по высоте: стопорный винт M3 в ступице, ступица через шайбу давит на
//  внутреннее кольцо. Ступица поднимается в зону без рёбер крышки — винт
//  над колесом, к нему свободный подход сбоку.
//
//  Печать: как есть, диском на стол, 100% заполнение ступицы.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>
use <../drive_lib.scad>

module drive_spindle_pulley() {
    translate([spindle_pos[0], spindle_pos[1], spindle_pulley_z0]) difference() {
        union() {
            pulley_wheel(spindle_pulley_od);
            chamfered_cyl(pulley_hub_d, spindle_hub_top - spindle_pulley_z0, ch = 0.5, bottom = false);
        }
        thru(spindle_d + rod_bore_clr, spindle_hub_top - spindle_pulley_z0);
        set_screw_hole(spindle_set_z - spindle_pulley_z0);
    }
}

drive_spindle_pulley();
