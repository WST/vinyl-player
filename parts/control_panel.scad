// ============================================================================
//  ПАНЕЛЬ УПРАВЛЕНИЯ (съёмная вставка в передней стенке поддона)
//
//  Смысл детали — модульность, как заглушки портов в корпусах ПК:
//  захотелось добавить регуляторы тембра, линейный выход или гнездо
//  наушников — правится только этот файл (список отверстий в params.scad)
//  и плата кнопок/регуляторов, поддон остаётся прежним.
//
//  Плата управления крепится к самой панельке на четыре стойки,
//  поэтому панель с платой снимается и ставится как один узел.
//
//  Печать: плашмя, лицом на стол (лицо получается ровным),
//  стойки печатаются вверх.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

// Отверстие под орган управления: сверлится по нормали к передней стенке
module panel_hole(x, d) {
    translate([x, -case_d/2 - eps, panel_z]) rotate([-90, 0, 0])
        cylinder(d = d, h = panel_t + 2*eps);
}

module control_panel() {
    difference() {
        union() {
            // плита с заплечиком, встаёт в четверть поддона заподлицо
            translate([0, -case_d/2 + panel_t/2, panel_z])
                cube([panel_plate[0], panel_t, panel_plate[1]], center = true);
            // стойки платы кнопок и регуляторов
            for (p = panel_pcb_hole)
                translate([p[0], -case_d/2 + panel_t, panel_z + p[1]])
                    rotate([-90, 0, 0])
                        screw_boss(scr25_boss_d, panel_pcb_h, scr25_pilot,
                                   panel_pcb_h - 1);
        }
        // органы управления
        for (x = panel_pot_x) panel_hole(x, panel_pot_d);
        for (x = panel_led_x) panel_hole(x, panel_led_d);
        for (x = panel_sw_x)  panel_hole(x, panel_sw_d);
        for (x = panel_btn_x) panel_hole(x, panel_btn_d);
        // крепление панели к поддону, потайные саморезы
        for (p = panel_scr_pos)
            translate([p[0], -case_d/2 + panel_t, p[1]]) rotate([90, 0, 0])
                countersunk_hole(scr25_free, scr25_head_d, panel_t);
    }
}

control_panel();
