// ============================================================================
//  КОЛПАЧОК ПРОМВАЛА — верхний бортик пассика 2
//
//  Надевается на верхний конец промвала (отверстие как у колёс,
//  плюс rod_ring_clr). При необходимости капля клея.
//  Нагрузки не несёт: только не даёт пассику соскочить с гладкого вала
//  вверх, когда он ослаблен или его надевают.
//
//  Печать: бортиком на стол.
// ============================================================================

include <../drive_params.scad>
use <../../lib/common.scad>

module drive_idler_cap() {
    translate([idler_pos[0], idler_pos[1], cap_z0]) difference() {
        union() {
            chamfered_cyl(cap_d, 1.2, ch = 0.3);
            chamfered_cyl(spindle_d + 4, cap_h, ch = 0.5, bottom = false);
        }
        thru(spindle_d + rod_bore_clr + rod_ring_clr - cap_fit, cap_h);
    }
}

drive_idler_cap();
