// ============================================================================
//  ПАНЕЛЬ РАЗЪЁМОВ (съёмная вставка в правой стенке поддона)
//
//  Та же схема, что у передней панели: окно с четвертью, панель заподлицо
//  снаружи. Сюда выводятся питание, линейный выход и прочее — список
//  отверстий в params.scad, поддон не трогается.
//
//  Печать: плашмя, лицом на стол (лицо получается ровным),
//  стойки печатаются вверх.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module io_hole(y, d) {
    translate([case_w/2 + eps, io_panel_y + y, io_panel_z]) rotate([0, -90, 0])
        cylinder(d = d, h = panel_t + 2*eps);
}

module io_panel() {
    difference() {
        union() {
            translate([case_w/2 - panel_t/2, io_panel_y, io_panel_z])
                cube([panel_t, io_panel_plate[0], io_panel_plate[1]], center = true);
            for (p = io_panel_pcb_hole)
                translate([case_w/2 - panel_t, io_panel_y + p[0], io_panel_z + p[1]])
                    rotate([0, -90, 0])
                        screw_boss(scr25_boss_d, io_panel_pcb_h, scr25_pilot,
                                   io_panel_pcb_h - 1);
        }
        for (y = io_dc_y)   io_hole(y, io_dc_d);
        for (y = io_jack_y) io_hole(y, io_jack_d);
        for (p = io_panel_scr_pos)
            translate([case_w/2 - panel_t, p[0], p[1]]) rotate([0, 90, 0])
                countersunk_hole(scr25_free, scr25_head_d, panel_t);
    }
}

io_panel();
