// ============================================================================
//  ГОЛОВКА (площадка под звукосниматель) — съёмная
//
//  Устройство простое: скруглённая площадка, на её задней части поднят
//  «нарост» того же контура, в нём под углом гнездо под трубку тонарма.
//  Задний угол срезан одной плоскостью перпендикулярно трубке — это вход
//  гнезда. Трубка входит до упора в глухое дно (упор задаёт эффективную
//  длину) и тянется винтом M2.5 сверху по лыске (лыска задаёт повторяемый
//  угол разворота). Больше в стыке ничего нет.
//
//  Зачем разъём: иначе сигнальный провод в тонарм не завести — трубка
//  оказывается заглушена со стороны головки. Плюс так можно поменять
//  звукосниматель, не разбирая тонарм.
//
//  Под AT91: пазы 1/2" с шагом 12.7 мм дают регулировку выноса +-4 мм.
//  Провод идёт дальше по оси трубки и выходит снизу площадки сразу позади
//  корпуса головки — как раз к её лепесткам.
//
//  Печать: площадкой на стол, наростом вверх, без поддержек.
// ============================================================================

include <../params.scad>
use <../lib/common.scad>

module tonearm_headshell(az = arm_tube_azimuth_at(arm_groove_r_out)) {
    // Пальцевой упор стоит в просвете между наростом и пазами крепления:
    // над пазами нельзя (нужен свободный ход винта и доступ отвёрткой),
    // впереди пазов площадка кончается у самой иглы.
    lift_w = 4;
    lift_x = (arm_shell_pad_x + arm_shell_slot_x - cart_slot_len/2)/2;

    // Контур площадки — одна скруглённая пластина
    module profile()
        translate([(arm_shell_front - arm_shell_rear)/2, 0])
            rrect(arm_shell_front + arm_shell_rear, arm_headshell_w, arm_shell_r);

    translate([arm_pivot_pos[0], arm_pivot_pos[1], arm_axis_z]) rotate([0, 0, az])
    difference() {
        translate([arm_tube_reach, 0, 0]) rotate([0, 0, -arm_headshell_angle]) {
            // площадка
            translate([0, 0, arm_shell_bot])
                linear_extrude(height = arm_headshell_t) profile();
            // нарост: тот же контур, поднят до верха гнезда
            translate([0, 0, arm_shell_bot])
                linear_extrude(height = arm_shell_pad_z - arm_shell_bot)
                    intersection() {
                        profile();
                        translate([-arm_shell_rear - 1, -arm_headshell_w])
                            square([arm_shell_pad_x + arm_shell_rear + 1,
                                    2*arm_headshell_w]);
                    }
            // «пальцевой» упор — за него берут тонарм. Уходит на внешнюю
            // сторону (от центра диска) и вверх, чтобы палец не проходил
            // над пластинкой.
            hull() {
                translate([lift_x, arm_headshell_w/2 - 3.5,
                           arm_shell_bot + arm_headshell_t/2])
                    cube([lift_w, 7, arm_headshell_t], center = true);
                translate([lift_x, arm_headshell_w/2 + 6,
                           arm_shell_bot + arm_headshell_t/2 + 6])
                    cube([lift_w, 4, 2.5], center = true);
            }
        }
        // ---- пазы крепления головки (регулировка выноса +-4 мм) ----
        translate([arm_tube_reach, 0, 0]) rotate([0, 0, -arm_headshell_angle])
            for (s = [-1, 1])
                translate([arm_shell_slot_x, s*cart_screw_spacing/2,
                           arm_shell_bot - eps])
                    slot(cart_slot_len, cart_screw_d, arm_headshell_t + 2*eps);
        // ---- вход гнезда: плоскость перпендикулярно трубке ----
        translate([arm_tube_reach - arm_joint_len - 100, -100, -100])
            cube([100, 200, 200]);
        // ---- гнездо трубки: глухое, дно на торце трубки ----
        translate([arm_tube_reach - arm_joint_len - 2, 0, 0]) rotate([0, 90, 0])
            cylinder(d = arm_socket_d, h = arm_joint_len + 2);
        // ---- канал провода: продолжение гнезда той же осью ----
        translate([arm_tube_reach - 1, 0, 0]) rotate([0, 90, 0])
            cylinder(d = arm_wire_exit_d, h = arm_wire_chan_fwd + 1);
        // ---- выход провода вниз, сразу позади корпуса головки ----
        translate([arm_tube_reach + 3, 0, arm_shell_bot - 1])
            cylinder(d = arm_wire_exit_d, h = -arm_shell_bot + 3);
        // ---- прижимной винт: сверху нароста в лыску трубки ----
        translate([arm_tube_reach - arm_joint_len/2, 0, arm_joint_scr_z - 0.5])
            cylinder(d = scr25_pilot, h = arm_shell_pad_t + 2);
    }
}

tonearm_headshell();
