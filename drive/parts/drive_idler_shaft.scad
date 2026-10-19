// ============================================================================
//  ПРОМВАЛ — печатный, садится в стакан шасси сверху
//
//  Без буртика: торец опирается на пятку стакана. Над колесом — участок
//  под пассик 2 (шкив второй ступени), сверху колпачок drive_idler_cap.
//  Лыска под винт колеса — rod_set_screws в drive_params.scad.
//
//  Печать: стоя, торцом на стол, 100% заполнение. Участок под пассиком
//  лучше слегка зашкурить для сцепления.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>
use <../drive_lib.scad>

module drive_idler_shaft() {
    translate([idler_pos[0], idler_pos[1], 0]) difference() {
        printed_shaft_body(idler_rod_top_z, bottom_z = idler_shaft_z0, collar = false);
        if (rod_set_screws) shaft_flat(idler_set_z);
    }
}

drive_idler_shaft();
