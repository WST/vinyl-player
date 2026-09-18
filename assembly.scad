// ============================================================================
//  СБОРКА ЦЕЛИКОМ — рабочий файл для проверки компоновки и зазоров.
//  Печатать отсюда ничего нельзя, детали лежат в parts/.
//
//  Все детали описаны в общих координатах, поэтому сборка — это просто
//  их перечисление. Ниже — выключатели: удобно погасить крышку и
//  посмотреть, что внутри.
// ============================================================================

include <params.scad>
use <lib/common.scad>

use <parts/tray.scad>
use <parts/top_cover.scad>
use <parts/bushing.scad>
use <parts/spindle.scad>
use <parts/platter.scad>
use <parts/pulley.scad>
use <parts/motor_pulley.scad>
use <parts/motor_mount.scad>
use <parts/control_panel.scad>
use <parts/tonearm_base.scad>
use <parts/tonearm_pin.scad>
use <parts/tonearm_yoke.scad>
use <parts/tonearm_arm.scad>
use <parts/tonearm_headshell.scad>
use <parts/tonearm_counterweight.scad>
use <parts/tonearm_rest.scad>

// ------------------------------------------------------------ что показывать
show_tray    = true;
show_cover   = true;    // выключить, чтобы заглянуть внутрь
show_drive   = true;
show_platter = true;    // выключить, чтобы увидеть привод под диском
show_panel   = true;
show_tonearm = true;
show_mockups = true;    // двигатель, платы, пластинка, головка — «болванки»

// Где сейчас стоит игла: 84 — начало записи, 53 — конец (7" сингл)
stylus_r = arm_groove_r_out;
park_arm = false;       // true — тонарм лежит на подставке

arm_az = park_arm ? arm_park_azimuth : arm_tube_azimuth_at(stylus_r);

// ============================================================== БОЛВАНКИ ===
// Это не детали для печати, а покупные/будущие узлы: нужны только чтобы
// видеть, что всё влезает и ничему не мешает.
module mock_motor() color("dimgray") {
    translate([motor_pos[0], motor_pos[1], floor_t]) {
        cylinder(d = motor_body_d, h = motor_body_h);
        cylinder(d = motor_shaft_d, h = motor_body_h + motor_shaft_len);
    }
}

module mock_belt() color("black")
    translate([0, 0, belt_plane_z]) linear_extrude(height = belt_d, center = true)
        difference() {
            hull() {
                translate(platter_pos) circle(d = pulley_d - 2*belt_groove_r);
                translate(motor_pos)   circle(d = motor_pulley_d - 2*belt_groove_r);
            }
            offset(delta = -belt_d) hull() {
                translate(platter_pos) circle(d = pulley_d - 2*belt_groove_r);
                translate(motor_pos)   circle(d = motor_pulley_d - 2*belt_groove_r);
            }
        };

module mock_main_pcb() color("darkgreen")
    translate([main_pcb_pos[0], main_pcb_pos[1], floor_t + pcb_standoff_h])
        cube([main_pcb[0], main_pcb[1], main_pcb_t], center = true);

module mock_panel_pcb() color("darkgreen")
    translate([0, -case_d/2 + panel_t + panel_pcb_h + main_pcb_t/2, panel_z])
        cube([panel_pcb[0], main_pcb_t, panel_pcb[1]], center = true);

module mock_mat() color("dimgray")
    translate([platter_pos[0], platter_pos[1],
               platter_top_z - platter_mat_recess])
        cylinder(d = platter_mat_d - 0.4, h = mat_t);

module mock_record() color("#202020")
    translate([platter_pos[0], platter_pos[1], record_z]) difference() {
        cylinder(d = record_d, h = record_t);
        thru(record_hole_d, record_t);
    }

// Головка AT91: габаритная болванка, подвешенная под площадку тонарма
module mock_cartridge(az) color("darkred")
    translate([arm_pivot_pos[0], arm_pivot_pos[1], arm_axis_z]) rotate([0, 0, az])
        translate([arm_tube_reach, 0, 0]) rotate([0, 0, -arm_headshell_angle])
            translate([arm_headshell_reach - cart_stylus_to_holes - cart_body[1]/2 + 3,
                       0, -(arm_tube_od/2 + arm_headshell_t) - cart_body[2]/2])
                cube([cart_body[1], cart_body[0], cart_body[2]], center = true);

// ============================================================== СБОРКА =====
if (show_tray)  color("gainsboro") tray();
if (show_cover) color("lightsteelblue") top_cover();
if (show_panel) color("steelblue") control_panel();

if (show_drive) {
    color("saddlebrown") bushing();
    color("silver")      spindle();
    if (show_platter) color("darkslategray") platter();
    color("dimgray")     pulley();
    color("dimgray")     motor_pulley();
    color("gray")        motor_mount();
}

if (show_tonearm) {
    color("gainsboro") tonearm_base();
    color("silver")    tonearm_pin();
    color("lightgray") tonearm_yoke(arm_az);
    color("whitesmoke") tonearm_arm(arm_az);
    color("white")     tonearm_headshell(arm_az);
    color("dimgray")   tonearm_counterweight(arm_az);
    color("gainsboro") tonearm_rest();
}

if (show_mockups) {
    mock_motor();
    mock_belt();
    mock_main_pcb();
    mock_panel_pcb();
    if (show_platter) { mock_mat(); mock_record(); }
    mock_cartridge(arm_az);
}
