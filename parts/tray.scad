// ============================================================================
//  ПОДДОН (нижняя часть корпуса)
//
//  Несёт: бобышки под модуль вращения (сам модуль — в drive/), стойки
//  платы фонокорректора/УМ, рамку съёмной панели управления и стойки под
//  саморезы крышки.
//
//  Печать: как есть, дном на стол, без поддержек.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

// ------------------------------------------------------------- оболочка ----
module tray_shell() {
    difference() {
        rounded_box(case_w, case_d, tray_h, corner_r);
        translate([0, 0, floor_t])
            rounded_box(inner_w, inner_d, inner_h + eps, inner_r);
    }
}

// --------------------------------------------- стойки под саморезы крышки --
module tray_screw_bosses() {
    for (p = case_screw_pos)
        translate([p[0], p[1], floor_t])
            screw_boss(scr3_boss_d, inner_h, scr3_pilot, scr3_depth, ch = 0);
}

// ------------------------------------------ бобышки модуля вращения -------
// Это весь интерфейс поддона с приводом: модуль ставится сверху и
// притягивается четырьмя саморезами 2.5 x 8.
module drive_mount_bosses() {
    for (p = drive_mount_pos)
        translate([p[0], p[1], floor_t])
            screw_boss(drive_mount_boss_d, drive_mount_boss_h, scr25_pilot,
                       drive_mount_boss_h + 0.5);
}

// ------------------------------------------------- рамка панели управления --
// Изнутри стенка локально утолщается, снаружи выбирается четверть под
// заплечик панельки — панель встаёт заподлицо с передней стенкой.
module panel_frame_pad() {
    translate([-panel_pad_x/2, -(case_d/2 - wall) - 0.5, panel_pad_z0])
        cube([panel_pad_x, panel_pad_t + 0.5, panel_pad_z1 - panel_pad_z0]);
}

module panel_screw_bosses() {
    for (p = panel_scr_pos)
        translate([p[0], -(case_d/2 - wall - panel_pad_t), p[1]])
            rotate([-90, 0, 0])
                cylinder(d = scr25_boss_d, h = panel_boss_len);
}

module panel_cutouts() {
    // окно
    translate([-panel_w/2, -case_d/2 - 1, panel_win_bot])
        cube([panel_w, wall + panel_pad_t + 2, panel_h]);
    // четверть под заплечик панельки
    translate([0, -case_d/2 - eps, panel_z])
        cube([panel_plate[0] + 2*panel_clr, 2*(panel_t + eps),
              panel_plate[1] + 2*panel_clr], center = true);
    // пилотные отверстия крепления панельки
    for (p = panel_scr_pos)
        translate([p[0], -case_d/2 - eps, p[1]])
            rotate([-90, 0, 0])
                cylinder(d = scr25_pilot,
                         h = wall + panel_pad_t + panel_boss_len + eps);
}

// ------------------------------------- стойки платы фонокорректора и УМ ----
module pcb_standoffs() {
    for (p = main_pcb_hole_pos)
        translate([p[0], p[1], floor_t])
            screw_boss(pcb_standoff_d, pcb_standoff_h, pcb_pilot, pcb_standoff_h - 0.8);
}

// --------------------------------------------------------------- деталь ----
module tray() {
    difference() {
        union() {
            tray_shell();
            tray_screw_bosses();
            drive_mount_bosses();
            panel_frame_pad();
            panel_screw_bosses();
            pcb_standoffs();
        }
        panel_cutouts();
    }
}

tray();
