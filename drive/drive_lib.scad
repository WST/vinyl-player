// ============================================================================
//  Вспомогательные модули модуля вращения (шкивы).
//  Подключать через use <../drive_lib.scad>.
// ============================================================================

include <drive_params.scad>
use <../lib/common.scad>

// Канавка под квадратный пассик: трапеция со дном чуть шире пассика и
// разведёнными стенками — пассик сам садится на дно.
module sq_belt_groove(od) {
    wb = belt_t + 0.2;
    wt = wb/2 + (pulley_groove_h + 0.5)*tan(30);
    rotate_extrude(angle = 360) polygon([
        [od/2 - pulley_groove_h, -wb/2],
        [od/2 - pulley_groove_h,  wb/2],
        [od/2 + 0.5,  wt],
        [od/2 + 0.5, -wt]]);
}

// Колесо без ступицы: обод с канавкой посередине, диск с окнами.
// web_top — диск у верхнего края обода (иначе у нижнего).
module pulley_wheel(od, web_top = false) {
    rim_id = od - 2*pulley_rim_w;
    win_r  = (rim_id/2 + pulley_hub_d/2)/2;
    win_d  = rim_id/2 - pulley_hub_d/2 - 5;
    difference() {
        union() {
            tube(od, rim_id, pulley_t);
            translate([0, 0, web_top ? pulley_t - pulley_web_t : 0])
                cylinder(d = rim_id + 1, h = pulley_web_t);
        }
        translate([0, 0, pulley_t/2]) sq_belt_groove(od);
        if (win_d > 6)
            translate([0, 0, web_top ? pulley_t - pulley_web_t : 0])
                radial_holes(5, win_r, win_d, pulley_web_t);
    }
}

// Отверстие под стопорный винт M3 в ступице, на высоте z от её низа
module set_screw_hole(z) translate([0, 0, z]) rotate([0, 90, 0])
    cylinder(d = scr3_pilot, h = pulley_hub_d);
