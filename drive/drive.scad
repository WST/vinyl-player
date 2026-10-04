// ============================================================================
//  МОДУЛЬ ВРАЩЕНИЯ В СБОРЕ — точка подключения «плагина».
//
//  Общая сборка (../assembly.scad) знает о приводе только модуль
//  drive_module(). Другая реализация привода — это другая папка drive/ с
//  тем же drive_module() и тем же интерфейсом из ../params.scad.
//
//  Болванки покупного (двигатель, подшипники, валы, пассики) — тоже здесь:
//  они часть модуля и меняются вместе с ним.
// ============================================================================

include <drive_params.scad>
use <../lib/common.scad>

use <parts/drive_chassis.scad>
use <parts/drive_spindle_pulley.scad>
use <parts/drive_spacer.scad>
use <parts/drive_idler_pulley.scad>
use <parts/drive_idler_cap.scad>
use <parts/drive_motor_holder.scad>

// ============================================================== БОЛВАНКИ ===
module mock_bearing(pos, z) color("silver")
    translate([pos[0], pos[1], z]) tube(brg_od, brg_id, brg_w);

// Упорное кольцо из термоусадки под нижним подшипником
module mock_stop_ring(pos) color("firebrick")
    translate([pos[0], pos[1], chassis_z0 - stop_ring_h])
        tube(stop_ring_d, spindle_d, stop_ring_h);

module mock_bearings(pos, top) {
    mock_bearing(pos, chassis_z0);
    mock_bearing(pos, top - brg_w);
    mock_stop_ring(pos);
}

module mock_spindle_rod() color("lightsteelblue")
    translate([spindle_pos[0], spindle_pos[1], rod_bottom_z]) {
        cylinder(d = spindle_d, h = spindle_tip_z - rod_bottom_z);
        cylinder(d = spindle_tip_d, h = spindle_rod_len);
    }

module mock_idler_rod() color("lightsteelblue")
    translate([idler_pos[0], idler_pos[1], rod_bottom_z])
        cylinder(d = spindle_d, h = idler_rod_len);

module mock_motor() translate([motor_pos[0], motor_pos[1], motor_base_z]) {
    color("dimgray") cylinder(d = motor_d, h = motor_h);
    // заводское колесо: два бортика и канавка между ними
    color("white") {
        translate([0, 0, motor_h + 0.3]) cylinder(d = motor_groove_d, h = motor_full_h - motor_h - 0.3);
        for (z = [motor_groove_z - 1.3, motor_groove_z + 0.7])
            translate([0, 0, z]) cylinder(d = motor_pulley_od, h = 0.6);
    }
    // провода сбоку у донца
    color("red") rotate([0, 0, motor_angle + motor_wire_angle])
        for (dy = [-1, 1]) translate([motor_d/2 - 1, dy*1.2, 2]) rotate([0, 90, 0])
            cylinder(d = 1.6, h = 12);
}

// Пассик по средней линии вокруг двух шкивов
module mock_belt(a, da, b, db, z) color("black")
    translate([0, 0, z - belt_t/2]) linear_extrude(height = belt_t) difference() {
        offset(r = belt_t/2) hull() { translate(a) circle(d = da); translate(b) circle(d = db); }
        offset(r = -belt_t/2) hull() { translate(a) circle(d = da); translate(b) circle(d = db); }
    }

module mock_reg_pcb() color("darkgreen")
    translate([reg_pcb_pos[0], reg_pcb_pos[1], reg_pcb_z + reg_pcb_t/2])
        cube([reg_pcb[0], reg_pcb[1], reg_pcb_t], center = true);

module drive_mocks() {
    mock_reg_pcb();
    mock_bearings(spindle_pos, spindle_tower_top);
    mock_bearings(idler_pos, idler_tower_top);
    mock_spindle_rod();
    mock_idler_rod();
    mock_motor();
    mock_belt(idler_pos, idler_pulley_pd, motor_pos, motor_pd, belt1_z);
    mock_belt(spindle_pos, spindle_pulley_pd, idler_pos, capstan_pd, belt2_z);
}

// ================================================================ МОДУЛЬ ===
module drive_module(mocks = true) {
    color("gainsboro") drive_chassis();
    color("dimgray")   drive_spindle_pulley();
    color("orange")    drive_spacer();
    color("slategray") drive_idler_pulley();
    color("orange")    drive_idler_cap();
    color("gray")      drive_motor_holder();
    if (mocks) drive_mocks();
}

drive_module();
