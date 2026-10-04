// ============================================================================
//  ШАССИ МОДУЛЯ ВРАЩЕНИЯ
//
//  Плита с двумя башнями под пары подшипников 608ZZ (вал диска и
//  промвал) и бобышками под держатель двигателя. Ставится в поддон на его
//  бобышки и притягивается четырьмя саморезами 2.5 x 8.
//
//  В каждой башне два гнезда: нижний подшипник запрессовывается снизу,
//  верхний — сверху, оба упираются наружным кольцом в перемычку между
//  гнёздами. Осевую нагрузку (диск, пластинка) держит верхний подшипник
//  вала диска.
//
//  Печать: как есть, плитой на стол, без поддержек (потолок нижнего гнезда —
//  узкое кольцо, мостится). Перед запрессовкой примерить подшипник: посадку
//  правит brg_seat_clr.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>

module tower_solid(pos, top) translate([pos[0], pos[1], chassis_z0]) {
    cylinder(d = tower_od, h = top - chassis_z0);
    for (a = [45 : 90 : 359]) rotate([0, 0, a])
        translate([tower_od/2 - 0.5, 0, chassis_t - eps])
            gusset(tower_gusset, min(tower_gusset, top - chassis_z1 - 2), chassis_rib_t);
}

module tower_bore(pos, top) translate([pos[0], pos[1], 0]) {
    // нижнее гнездо + заходная фаска
    translate([0, 0, chassis_z0 - eps]) {
        cylinder(d = seat_d, h = brg_w + eps);
        cylinder(d1 = seat_d + 1, d2 = seat_d, h = 0.5);
    }
    // проход между гнёздами: упор только в наружные кольца
    translate([0, 0, chassis_z0]) cylinder(d = brg_outer_ring_d, h = top - chassis_z0 + eps);
    // верхнее гнездо + заходная фаска
    translate([0, 0, top - brg_w]) cylinder(d = seat_d, h = brg_w + eps);
    translate([0, 0, top - 0.5]) cylinder(d1 = seat_d, d2 = seat_d + 1, h = 0.5 + eps);
}

module chassis_plate() {
    translate([(chassis_x0 + chassis_x1)/2, (chassis_y0 + chassis_y1)/2, chassis_z0])
        rounded_box(chassis_x1 - chassis_x0, chassis_y1 - chassis_y0, chassis_t, chassis_r);
}

module rib(a, b) hull() for (p = [a, b])
    translate([p[0], p[1], chassis_z1 - eps])
        cylinder(d = chassis_rib_t, h = chassis_rib_h + eps, $fn = 12);

// Рёбра: рамка по краю плиты и лучи от башен к точкам крепления.
// Под держателем двигателя рёбер нет — там его ход по пазам.
module chassis_ribs() difference() {
    union() {
        translate([(chassis_x0 + chassis_x1)/2, (chassis_y0 + chassis_y1)/2, chassis_z1 - eps])
            difference() {
                rounded_box(chassis_x1 - chassis_x0, chassis_y1 - chassis_y0,
                            chassis_rib_h + eps, chassis_r);
                translate([0, 0, -eps])
                    rounded_box(chassis_x1 - chassis_x0 - 2*chassis_rib_t,
                                chassis_y1 - chassis_y0 - 2*chassis_rib_t,
                                chassis_rib_h + 3*eps, max(0.5, chassis_r - chassis_rib_t));
            }
        rib(spindle_pos, idler_pos);
        for (p = drive_mount_pos) {
            rib(spindle_pos, p);
            rib(idler_pos, p);
        }
    }
    translate([motor_pos[0], motor_pos[1], 0]) thru(2*holder_keepout_r, drive_ceiling_z);
}

module holder_bosses() for (p = holder_boss_pos)
    translate([p[0], p[1], chassis_z1 - eps])
        chamfered_cyl(holder_boss_d, holder_boss_h + eps, ch = 0.5, bottom = false);

module drive_chassis() {
    difference() {
        union() {
            chassis_plate();
            chassis_ribs();
            holder_bosses();
            tower_solid(spindle_pos, spindle_tower_top);
            tower_solid(idler_pos, idler_tower_top);
        }
        tower_bore(spindle_pos, spindle_tower_top);
        tower_bore(idler_pos, idler_tower_top);
        // крепление к поддону
        for (p = drive_mount_pos)
            translate([p[0], p[1], chassis_z0]) thru(scr25_free, chassis_t + chassis_rib_h);
        // держатель двигателя: пилотные насквозь, длина самореза не критична
        for (p = holder_boss_pos)
            translate([p[0], p[1], chassis_z0]) thru(scr25_pilot, chassis_t + holder_boss_h);
    }
}

drive_chassis();
