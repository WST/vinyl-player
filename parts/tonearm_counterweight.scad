// ============================================================================
//  ПРОТИВОВЕС ТОНАРМА
//
//  Стакан, который надевается на хвостовик и фиксируется винтом.
//  Полость сзади засыпается дробью/гайками М8 и заливается эпоксидкой:
//  так массу можно подобрать под конкретную головку (для AT91 с
//  прижимной силой ~2 г нужно порядка 25-30 г на вылете ~30 мм).
//  Точная настройка — продольным перемещением по хвостовику.
//
//  Печать: стоя, открытой полостью вверх.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module tonearm_counterweight(az = arm_tube_azimuth_at(arm_groove_r_out)) {
    bore_d  = arm_cw_stub_d + arm_cw_bore_clr;
    hub_od  = bore_d + 2*arm_cw_wall;
    cav_d   = arm_cw_d - 2*arm_cw_wall;
    cav_h   = arm_cw_h - 4;
    cw_x    = -(arm_cw_center_dist + arm_cw_h/2);   // задний торец стакана
    translate([arm_pivot_pos[0], arm_pivot_pos[1], arm_axis_z]) rotate([0, 0, az])
    translate([cw_x, 0, 0]) rotate([0, 90, 0]) difference() {
        union() {
            chamfered_cyl(arm_cw_d, arm_cw_h, ch = 1);
            cylinder(d = hub_od, h = arm_cw_h);
        }
        // полость под груз (открыта в сторону хвостовика)
        difference() {
            translate([0, 0, -eps]) cylinder(d = cav_d, h = cav_h + eps);
            translate([0, 0, -2*eps]) cylinder(d = hub_od, h = cav_h + 4*eps);
        }
        // посадка на хвостовик
        thru(bore_d, arm_cw_h);
        // фиксирующий винт — в сплошной передней части стакана, а не в полости
        translate([0, 0, arm_cw_h - 2]) rotate([0, 90, 0])
            cylinder(d = scr3_pilot, h = arm_cw_d);
    }
}

tonearm_counterweight();
