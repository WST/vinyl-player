// ============================================================================
//  МОДУЛЬ ВРАЩЕНИЯ — ПРЕВЬЮ УЗЛА ОТДЕЛЬНО ОТ ВСЕГО ПРОИГРЫВАТЕЛЯ
//
//  Рабочий файл для доработки привода: показывает модуль в сборе, а вокруг
//  него — полупрозрачные поддон и границы отсека (за них модулю нельзя).
//  Печатать отсюда ничего нельзя, детали лежат в parts/.
//  Сводка (редукция, какие пассики брать, длины валов) — в консоли.
// ============================================================================

include <drive_params.scad>
use <../lib/common.scad>
use <drive.scad>
use <../parts/tray.scad>
use <../parts/platter.scad>

// ------------------------------------------------------------ что показывать
show_mocks   = true;    // двигатель, подшипники, валы, пассики
show_tray    = true;    // поддон (полупрозрачно)
show_bay     = true;    // разрешённый объём модуля (полупрозрачно)
show_platter = false;   // диск с пластинкой над крышкой
section      = false;   // разрез вертикальной плоскостью через оба вала

// Разрез: убирает половину сцены по одну сторону от линии «вал диска — промвал»
module cut() {
    if (section) difference() {
        children();
        translate([spindle_pos[0], spindle_pos[1], -1]) rotate([0, 0, idler_angle])
            translate([-200, 0, 0]) cube([400, 200, 200]);
    } else children();
}

// Отсек и потолок: под рёбрами крышки и выше — в зоне без рёбер вокруг вала
module bay_volume() {
    translate([drive_bay[0][0], drive_bay[0][1], drive_floor_z])
        cube([drive_bay[1][0] - drive_bay[0][0], drive_bay[1][1] - drive_bay[0][1],
              drive_ceiling_z - drive_floor_z]);
    translate([spindle_pos[0], spindle_pos[1], drive_ceiling_z])
        cylinder(d = spindle_keepout_d, h = drive_spindle_ceiling_z - drive_ceiling_z);
}

cut() drive_module(mocks = show_mocks);
if (show_platter) cut() color("darkslategray") platter();
if (show_tray) %tray();
if (show_bay)  %bay_volume();
