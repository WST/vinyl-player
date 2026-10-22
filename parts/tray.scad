// ============================================================================
//  ПОДДОН (нижняя часть корпуса)
//
//  Несёт: бобышки под модуль вращения (сам модуль — в drive/), стойки
//  платы фонокорректора/УМ под тонармом, направляющие динамиков со щелями
//  решётки в боковых стенках, рамки съёмных панелей (передняя — управление,
//  правая — разъёмы) и стойки под саморезы крышки.
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

// ------------------------------------------- рамка панели разъёмов (справа) --
module io_panel_frame_pad() {
    translate([case_w/2 - wall - panel_pad_t, io_panel_pad_y0, io_panel_pad_z0])
        cube([panel_pad_t + 0.5, io_panel_pad_y1 - io_panel_pad_y0,
              io_panel_pad_z1 - io_panel_pad_z0]);
}

module io_panel_screw_bosses() {
    for (p = io_panel_scr_pos)
        translate([case_w/2 - wall - panel_pad_t, p[0], p[1]])
            rotate([0, 90, 0])
                cylinder(d = scr25_boss_d, h = panel_boss_len);
}

module io_panel_cutouts() {
    translate([case_w/2 - wall - panel_pad_t - 1, io_panel_y - io_panel_w/2, io_win_bot])
        cube([wall + panel_pad_t + 2, io_panel_w, io_panel_h]);
    translate([case_w/2 + eps, io_panel_y, io_panel_z])
        cube([2*(panel_t + eps), io_panel_plate[0] + 2*panel_clr,
              io_panel_plate[1] + 2*panel_clr], center = true);
    for (p = io_panel_scr_pos)
        translate([case_w/2 + eps, p[0], p[1]])
            rotate([0, 90, 0])
                cylinder(d = scr25_pilot,
                         h = wall + panel_pad_t + panel_boss_len + eps);
}

// --------------------------------------------------------- динамики -------
// Модули ниже строят узел у правой стенки, левый получается зеркалом.
// Две направляющие уголком: тот же паз, что держал фланец на трении,
// но сдвинут от стенки на spk_face_gap — подвес диффузора не прижат.
// Передний упор паза только у краёв фланца; напротив диффузора — воздух.
// Динамик опускается сверху до дна. Вверху паз расширен под заход.
module speaker_rail() {
    lip_y0 = spk_rail_y - spk_rail_lip - spk_clr;
    difference() {
        translate([0, 0, floor_t - eps]) linear_extrude(height = spk_size + eps) {
            translate([spk_face_x - spk_rail_depth, spk_rail_y])
                square([spk_rail_depth + spk_face_gap + eps, spk_rail_t]);
            translate([spk_face_x - spk_rail_depth, lip_y0])
                square([spk_rail_t, spk_rail_y - lip_y0 + eps]);
            translate([spk_face_x, lip_y0])
                square([spk_face_gap + eps, spk_rail_y - lip_y0 + eps]);
        }
        hull() {
            translate([spk_face_x - spk_chan, lip_y0 - 1, floor_t + spk_size - 2])
                cube([spk_chan, spk_rail_y - lip_y0 + 1, eps]);
            translate([spk_face_x - spk_chan - 1.2, lip_y0 - 1, floor_t + spk_size])
                cube([spk_chan + 1.2, spk_rail_y - lip_y0 + 1, eps]);
        }
    }
}

module speaker_mounts() for (sx = [0, 1]) mirror([sx, 0, 0])
    translate([0, spk_y, 0]) for (sy = [0, 1]) mirror([0, sy, 0]) speaker_rail();

// Вертикальные щели перед диффузором, длина — по хорде его круга
module speaker_grilles() for (sx = [0, 1]) mirror([sx, 0, 0])
    for (i = [-grille_n : grille_n]) {
        y = i*grille_pitch;
        h = 2*sqrt(grille_r*grille_r - y*y);
        translate([spk_wall_x - 1, spk_y + y, spk_zc]) rotate([0, 90, 0])
            hull() for (s = [-1, 1]) translate([s*(h - grille_slot_w)/2, 0, 0])
                cylinder(d = grille_slot_w, h = wall + 2);
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
            io_panel_frame_pad();
            io_panel_screw_bosses();
            pcb_standoffs();
            speaker_mounts();
        }
        panel_cutouts();
        io_panel_cutouts();
        speaker_grilles();
    }
}

tray();
