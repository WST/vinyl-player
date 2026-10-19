// ============================================================================
//  ШАССИ МОДУЛЯ ВРАЩЕНИЯ
//
//  Плита: башня под два 608ZZ вала диска, стакан-втулка промвала,
//  бобышки держателя двигателя и стойки платы регулятора. Ставится
//  в поддон на его бобышки и притягивается четырьмя саморезами 2.5 x 8.
//
//  Башня вала диска: нижний подшипник запрессовывается снизу, верхний —
//  сверху, оба упираются наружным кольцом в перемычку. Осевую нагрузку
//  (диск, пластинка) держит верхний подшипник.
//
//  Промвал садится в стакан сверху: дно закрыто (пятка), два рабочих
//  пояска и карман для смазки. Посадку правит idler_bush_clr — перепечатать
//  шасси. Печать плитой на стол, без поддержек.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>

module tower_solid(pos, top) translate([pos[0], pos[1], chassis_z0]) {
    cylinder(d = tower_od, h = top - chassis_z0);
    for (a = [45 : 90 : 359]) rotate([0, 0, a])
        translate([tower_od/2 - 0.5, 0, chassis_t - eps])
            gusset(tower_gusset, min(tower_gusset, top - chassis_z1 - 2), chassis_rib_t);
}

// Стакан промвала растёт из плиты. Канал не сквозной: торец вала
// опирается на пятку. Два пояска держат вал, расточка между ними —
// карман для литола.
module idler_well_solid() translate([idler_pos[0], idler_pos[1], chassis_z0]) {
    cylinder(d = idler_bush_od, h = idler_bush_top - chassis_z0);
    for (a = [45 : 90 : 359]) rotate([0, 0, a])
        translate([idler_bush_od/2 - 0.5, 0, chassis_t - eps])
            gusset(tower_gusset, min(tower_gusset, idler_bush_top - chassis_z1 - 2), chassis_rib_t);
}

module idler_well_bore() translate([idler_pos[0], idler_pos[1], 0]) {
    z0 = chassis_z0 + idler_thrust_t;
    h  = idler_bush_top - z0;
    translate([0, 0, z0]) cylinder(d = idler_bush_id, h = h + eps);
    translate([0, 0, z0 + idler_bush_land])
        cylinder(d = idler_bush_id + idler_bush_relief,
                 h = h - 2*idler_bush_land);
    translate([0, 0, idler_bush_top - idler_mouth_ch])
        cylinder(d1 = idler_bush_id, d2 = idler_bush_id + 2*idler_mouth_ch,
                 h = idler_mouth_ch + eps);
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
    // прилив под плату регулятора
    translate([(reg_pad_x0 + reg_pad_x1)/2, (reg_pad_y0 + reg_pad_y1)/2, chassis_z0])
        rounded_box(reg_pad_x1 - reg_pad_x0, reg_pad_y1 - reg_pad_y0, chassis_t, chassis_r);
}

module reg_standoffs() for (p = reg_hole_pos)
    translate([p[0], p[1], chassis_z1 - eps])
        screw_boss(reg_standoff_d, reg_standoff_h + eps, scr25_pilot, reg_standoff_h - 1);

module rib(a, b) hull() for (p = [a, b])
    translate([p[0], p[1], chassis_z1 - eps])
        cylinder(d = chassis_rib_t, h = chassis_rib_h + eps, $fn = 12);

// Рёбра: рамка по краю плиты и лучи от башен к точкам крепления.
// Под держателем двигателя рёбер нет — там его ход по пазам.
// Вокруг крепежа к поддону — круглая площадка под гайку.
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
    for (p = drive_mount_pos)
        translate([p[0], p[1], chassis_z1])
            cylinder(d = chassis_nut_keepout, h = chassis_rib_h + 2*eps);
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
            reg_standoffs();
            tower_solid(spindle_pos, spindle_tower_top);
            idler_well_solid();
        }
        tower_bore(spindle_pos, spindle_tower_top);
        idler_well_bore();
        // крепление к поддону
        for (p = drive_mount_pos)
            translate([p[0], p[1], chassis_z0]) thru(scr25_free, chassis_t + chassis_rib_h);
        // держатель двигателя: пилотные насквозь, длина самореза не критична
        for (p = holder_boss_pos)
            translate([p[0], p[1], chassis_z0]) thru(scr25_pilot, chassis_t + holder_boss_h);
    }
}

drive_chassis();
