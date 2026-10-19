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

// Лыска под стопорный винт на печатном валу. z, az — в координатах сборки
// относительно оси вала (z абсолютный).
module shaft_flat(z, az = 0)
    rotate([0, 0, az])
        translate([rod_print_d/2 - rod_flat_d, -rod_flat_w/2, z - rod_flat_len/2])
            cube([rod_flat_d + 2, rod_flat_w, rod_flat_len]);

// Тело печатного вала на оси [0,0]. z — абсолютные координаты сборки.
// collar — буртик-упор снизу (вал диска). Промвал без буртика: торец
// садится на пятку стакана, bottom_z = idler_shaft_z0.
module printed_shaft_body(top_z, tip_len = 0, bottom_z = undef, collar = true) {
    z0 = bottom_z == undef ? rod_bottom_z : bottom_z;
    body_h = top_z - z0 - tip_len;
    translate([0, 0, z0]) {
        if (collar)
            translate([0, 0, rod_bottom_z - z0])
                chamfered_cyl(stop_ring_d, rod_bottom_gap, ch = 0.4, bottom = false);
        chamfered_cyl(rod_print_d, body_h, ch = 0.4, bottom = true,
                      top = tip_len <= 0);
        if (tip_len > 0)
            translate([0, 0, body_h])
                chamfered_cyl(spindle_tip_d, tip_len, ch = 0.4, bottom = false);
    }
}
