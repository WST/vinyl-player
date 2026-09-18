// ============================================================================
//  ВИЛКА ТОНАРМА
//
//  Вращается вместе с трубкой вокруг вертикальной оси (палец в стойке),
//  а трубка качается в вилке на двух винтах M3 с заточенными концами —
//  они входят в конусные гнёзда ступицы. Это простейший кардан:
//  зазор выставляется глубиной завинчивания винтов.
//
//  Печать: как есть, нижней плоскостью траверсы на стол — стойки
//  печатаются вверх, поддержки не нужны.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module tonearm_yoke(az = arm_tube_azimuth_at(arm_groove_r_out)) {
    bar_w  = arm_yoke_gap + 2*arm_yoke_upright_t;
    up_y   = arm_yoke_gap/2 + arm_yoke_upright_t/2;
    translate([arm_pivot_pos[0], arm_pivot_pos[1], 0]) rotate([0, 0, az])
        difference() {
            union() {
                // траверса
                translate([0, 0, arm_pillar_top_z])
                    linear_extrude(height = arm_yoke_bar_t)
                        rrect(arm_yoke_upright_w, bar_w, 3);
                // стойки вилки со скруглённым верхом
                for (s = [-1, 1]) translate([0, s*up_y, 0]) hull() {
                    translate([-arm_yoke_upright_w/2, -arm_yoke_upright_t/2,
                               arm_pillar_top_z])
                        cube([arm_yoke_upright_w, arm_yoke_upright_t,
                              arm_axis_z - arm_pillar_top_z]);
                    translate([0, 0, arm_axis_z]) rotate([90, 0, 0])
                        cylinder(d = arm_yoke_upright_w, h = arm_yoke_upright_t,
                                 center = true);
                }
            }
            // посадка пальца вертикальной оси (с натягом)
            translate([0, 0, arm_pillar_top_z - eps])
                cylinder(d = arm_pivot_shaft_d - 0.15, h = arm_yoke_bar_t + 2*eps);
            // пилотные отверстия винтов-осей качания
            translate([0, 0, arm_axis_z]) rotate([90, 0, 0])
                cylinder(d = arm_pivot_screw_pilot, h = bar_w + 10, center = true);
        }
}

tonearm_yoke();
