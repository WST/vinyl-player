// ============================================================================
//  ВЕРХНЯЯ ЧАСТЬ КОРПУСА (крышка)
//
//  Плоская панель со внутренним бортиком, который входит в поддон и
//  центрирует крышку. Крепится потайными саморезами в стойки поддона.
//  Снизу — рёбра жёсткости (панель 250x200x3 без них «играет»).
//
//  Отверстия: проём вокруг вала, крепёж стойки тонарма и его подставки,
//  проход сигнального провода внутрь корпуса.
//
//  Печать: как есть, наружной плоскостью на стол (перевернуть в слайсере),
//  тогда бортик и рёбра печатаются вверх и поддержки не нужны.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module cover_plate() {
    translate([0, 0, tray_h]) rounded_box(case_w, case_d, cover_plate_t, corner_r);
}

// Бортик, входящий внутрь поддона
module cover_lip() {
    lip_w = inner_w - 2*cover_lip_clr;
    lip_d = inner_d - 2*cover_lip_clr;
    difference() {
        translate([0, 0, tray_h - cover_lip_h])
            rounded_box(lip_w, lip_d, cover_lip_h + eps, inner_r);
        translate([0, 0, tray_h - cover_lip_h - eps])
            rounded_box(lip_w - 2*cover_lip_t, lip_d - 2*cover_lip_t,
                        cover_lip_h + 3*eps, max(0.5, inner_r - cover_lip_t));
    }
}

// Рёбра жёсткости на изнанке
module cover_ribs() {
    nx = floor((inner_w/2 - 20)/cover_rib_pitch);
    ny = floor((inner_d/2 - 20)/cover_rib_pitch);
    intersection() {
        union() {
            for (i = [-nx : nx])
                translate([i*cover_rib_pitch - cover_rib_t/2, -inner_d/2,
                           tray_h - cover_rib_h])
                    cube([cover_rib_t, inner_d, cover_rib_h + eps]);
            for (i = [-ny : ny])
                translate([-inner_w/2, i*cover_rib_pitch - cover_rib_t/2,
                           tray_h - cover_rib_h])
                    cube([inner_w, cover_rib_t, cover_rib_h + eps]);
        }
        translate([0, 0, tray_h - cover_rib_h - eps])
            rounded_box(inner_w - 2*cover_lip_clr - 2*cover_lip_t + 1,
                        inner_d - 2*cover_lip_clr - 2*cover_lip_t + 1,
                        cover_rib_h + 3*eps, max(0.5, inner_r - cover_lip_t));
    }
}

// Места, где ни бортику, ни рёбрам быть нельзя: стойки поддона, зона над
// модулем вращения вокруг вала, крепёж тонарма (саморезы вкручиваются
// снизу — нужен доступ)
module cover_keepout() {
    for (p = case_screw_pos)
        translate([p[0], p[1], 0]) thru(scr3_boss_d + 3, case_h + 1);
    translate([platter_pos[0], platter_pos[1], 0]) thru(spindle_keepout_d, case_h + 1);
    translate([arm_pivot_pos[0], arm_pivot_pos[1], 0])
        thru(arm_base_flange_d - 6, case_h + 1);
    for (p = concat(arm_base_scr_pos, arm_rest_scr_pos))
        translate([p[0], p[1], 0]) thru(scr25_head_d + 5, case_h + 1);
}

module cover_holes() {
    // саморезы крепления крышки к поддону
    for (p = case_screw_pos)
        translate([p[0], p[1], tray_h])
            countersunk_hole(scr3_free, scr3_head_d, cover_plate_t);
    // проём вокруг вала
    translate([platter_pos[0], platter_pos[1], 0])
        thru(cover_spindle_hole_d, case_h);
    // стойка тонарма: три винта снизу + проход провода
    for (p = arm_base_scr_pos)
        translate([p[0], p[1], 0]) thru(scr25_free, case_h);
    translate([arm_pivot_pos[0], arm_pivot_pos[1], 0])
        thru(arm_wire_hole_d, case_h);
    // подставка тонарма: два винта снизу
    for (p = arm_rest_scr_pos)
        translate([p[0], p[1], 0]) thru(scr25_free, case_h);
}

module top_cover() {
    difference() {
        union() {
            cover_plate();
            difference() {
                union() {
                    cover_lip();
                    cover_ribs();
                }
                cover_keepout();
            }
        }
        cover_holes();
    }
}

top_cover();
