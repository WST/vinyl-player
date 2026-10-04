// ============================================================================
//  Мини-проигрыватель виниловых пластинок (7", 33 1/3 об/мин)
//  ОБЩИЙ ФАЙЛ ПАРАМЕТРОВ — единственное место, где задаются размеры.
//
//  Все линейные размеры в миллиметрах, углы в градусах.
//
//  Система координат (общая для всех деталей и для сборки):
//    X — вдоль широкой стороны корпуса (250 мм), 0 — середина
//    Y — вдоль глубины корпуса (200 мм), 0 — середина, -Y — «передок»
//    Z — вверх, 0 — внешняя плоскость дна поддона
//
//  Каждая деталь описана в СВОИХ координатах сборки, т.е. если открыть
//  assembly.scad, всё стоит на своих местах без дополнительных сдвигов.
//  Для печати детали разворачиваются в Makefile/слайсере.
// ============================================================================

// ---------------------------------------------------------------- рендер ----
$fa = 3;      // максимальный угол фрагмента
$fs = 0.6;    // минимальный размер фрагмента
eps = 0.01;   // технологический «нахлёст» для булевых операций

// ============================================================================
//  КОРПУС
// ============================================================================
case_w = 250;           // габарит по X
case_d = 200;           // габарит по Y
case_h = 50;            // габарит по Z (поддон + крышка, без диска)

wall     = 2;           // толщина стенок
floor_t  = 2;           // толщина дна поддона
corner_r = 6;           // скругление ВЕРТИКАЛЬНЫХ (боковых) рёбер;
                        // нижние и верхние рёбра оставляем острыми

cover_plate_t = 3;      // толщина верхней панели
cover_lip_h   = 5;      // высота бортика, входящего внутрь поддона
cover_lip_t   = 1.6;    // толщина этого бортика
cover_lip_clr = 0.3;    // зазор бортика по стенкам поддона
cover_rib_t   = 2;      // рёбра жёсткости на изнанке крышки
cover_rib_h   = 4;
cover_rib_pitch = 45;
cover_spindle_hole_d = 12;  // проём в крышке вокруг вала

// ------------------------------------------------------------------ крепёж --
// Корпусные саморезы 3.0 x 12 с потайной головкой
scr3_pilot  = 2.5;      // отверстие «под вкручивание»
scr3_free   = 3.3;      // проходное отверстие
scr3_head_d = 5.8;
scr3_boss_d = 9;
scr3_depth  = 11;       // глубина пилотного отверстия в стойке

// Мелкие саморезы 2.5 x 10 (панель управления, платы, тонарм)
scr25_pilot  = 2.1;
scr25_free   = 2.8;
scr25_head_d = 5.0;
scr25_boss_d = 6.5;
scr25_depth  = 9;

// ============================================================================
//  ПАНЕЛЬ УПРАВЛЕНИЯ (съёмная, в передней стенке поддона)
//  Идея: хотим добавить тембр/линейный выход/наушники — переделываем
//  только эту деталь и её плату, поддон не трогаем.
// ============================================================================
panel_w = 140;          // окно в стенке по X
panel_h = 26;           // окно в стенке по Z
panel_z = 20;           // высота центра окна над столом
panel_t = 2;            // толщина самой панельки
panel_flange = 7;       // заплечик панельки (нахлёст на рамку поддона)
panel_clr = 0.25;       // зазор панельки в рамке
panel_pad_t = 2.5;      // местное утолщение стенки изнутри вокруг окна
panel_pad_w = 12;       // на сколько это утолщение выходит за окно
panel_scr_off = 3.5;    // центр крепёжного винта от кромки окна
panel_boss_len = 6;     // вылет крепёжной бобышки внутрь корпуса

// Элементы управления: X — от центра панели, все на средней линии окна.
// Менять здесь — это и есть «доработка панельки».
panel_pot_d  = 7.2;     // резьбовая шейка потенциометра 6 мм
panel_pot_x  = [-52, -26];   // громкость, задел под тембр
panel_led_d  = 5.2;
panel_led_x  = [0];
panel_sw_d   = 6.6;     // тумблер/кнопка питания
panel_sw_x   = [16];
panel_btn_d  = 12.2;    // кнопка «стоп/старт»
panel_btn_x  = [46];

// Плата кнопок и регуляторов крепится к самой панельке
panel_pcb      = [120, 20];
panel_pcb_h    = 8;         // высота стоек (зазор панель → плата)
panel_pcb_hole = [[-54, -6], [54, -6], [-54, 6], [54, 6]];

// ============================================================================
//  ДИСК И ВАЛ
//  Всё, что под крышкой (подшипники, шкивы, двигатель), — это модуль
//  вращения в drive/. Здесь только то, что видят остальные детали:
//  где ось, какого диаметра вал и как высоко он торчит.
// ============================================================================
platter_d   = 170;          // поддерживаются только 7" пластинки
platter_h   = 9;
platter_pos = [-25, 0];     // ось вращения в плане (смещена влево, справа тонарм)
platter_gap = 1.0;          // зазор между диском и крышкой корпуса
platter_top_t  = 3;         // толщина рабочей плоскости диска
platter_rim_t  = 2.5;       // толщина обода
platter_hub_d  = 16;
platter_hub_h  = 9;         // ступица не должна выступать над плоскостью диска
platter_spokes = 6;
platter_mat_d  = 164;       // утопление под мат (войлок/резина)
platter_mat_recess = 1.0;
mat_t = 2;                  // толщина мата (в расчёте высоты тонарма)

record_d      = 178;        // 7" пластинка (для сборки/проверок)
record_t      = 1.6;
record_hole_d = 7.3;

// Вал — стальной пруток 8 мм. Верхний конец сточен до 7.1 мм: он же
// центрирующий штырь под отверстие пластинки.
spindle_d     = 8;
spindle_tip_d = 7.1;
spindle_above_record = 7;   // сколько вал выступает над пластинкой
set_access_d = 4.5;         // технологические отверстия к стопорным винтам

platter_rpm = 33.333;

// ============================================================================
//  МОДУЛЬ ВРАЩЕНИЯ: ИНТЕРФЕЙС С ПОДДОНОМ
//  Модуль (вал, подшипники, редукция, двигатель) — отдельный «плагин» в
//  drive/, ставится в поддон на четыре бобышки. Поддон знает только то,
//  что ниже: отсек, точки крепления и потолок. Переделка привода — это
//  правка drive/, поддон и крышка при этом не меняются.
// ============================================================================
// Отсек: за боковыми стенками будут динамики, за передней — плата
// управления, поэтому от них держим не меньше 30 мм. Справа — тонарм и
// плата УМ, сзади — место под будущие разъёмы.
drive_keep_side  = 30;
drive_keep_front = 30;
drive_keep_back  = 12;
drive_bay_x1     = 40;

// Бобышки под шасси модуля: саморезы 2.5 x 8 сверху через шасси
drive_mount_pos    = [[-82, -50], [22, -50], [-82, 72], [22, 72]];
drive_mount_boss_d = 8;
drive_mount_boss_h = 5;

// Вокруг вала крышка без рёбер — там модулю можно подниматься почти
// до самой крышки (ступица колеса со стопорным винтом)
spindle_keepout_d = 32;

// ============================================================================
//  ТОНАРМ
//  Геометрия рассчитана по Бервальду (Löfgren A) для рабочей зоны
//  радиусов 53…84 мм (7" сингл): нулевые точки 56.0 и 77.4 мм,
//  максимальная погрешность тангенциальности 0.57°.
//  Головка звукоснимателя — Audio-Technica AT91 (1/2", 2 винта M2.5).
// ============================================================================
arm_groove_r_in  = 53;      // внутренний радиус фонограммы
arm_groove_r_out = 84;      // внешний радиус фонограммы
arm_eff_len      = 130;     // эффективная длина: игла → вертикальная ось
arm_overhang     = 17.9;    // заход иглы за ось диска
arm_offset_angle = 30.9;    // разворот головки
arm_azimuth      = 21;      // где стоит стойка относительно оси диска
                            // (подобран так, чтобы противовес не вылезал
                            //  за заднюю стенку на всём ходе тонарма)

cart_height   = 16;         // AT91: посадочная плоскость → кончик иглы
cart_body     = [17, 17.5, 16];  // габарит для проверки в сборке (Ш x Д x В)
cart_screw_spacing = 12.7;  // стандарт 1/2"
cart_screw_d  = 2.3;        // под винты M2 (головка M2 через паз не проходит)
cart_slot_len = 8;          // пазы регулировки выноса
cart_stylus_to_holes = 9.5; // от иглы до линии крепёжных отверстий

arm_tube_od   = 10;
arm_tube_id   = 6.4;        // канал сигнального провода AT91 (4 жилы)

// Головка — отдельная деталь: на площадке поднят «нарост» её же формы, в нём
// наклонное гнездо под трубку. Трубка входит до упора в глухое дно гнезда и
// тянется винтом по лыске. Так провод протягивается через открытую с торца
// трубку до установки головки, а саму головку можно снять и поменять.
arm_joint_len    = 9;       // глубина гнезда: посадка трубки
arm_joint_clr    = 0.3;     // зазор гнезда по трубке
arm_joint_flat_d = 0.8;     // глубина лыски на трубке под прижимной винт
arm_shell_rear   = 12;      // сколько площадки уходит назад за торец трубки
arm_shell_pad_x  = 8;       // до какого места поднят нарост (вперёд от торца)
arm_wire_chan_fwd = 6;      // насколько канал провода уходит вперёд за торец
arm_shell_pad_t  = 3;       // материал над лыской: в него врезается винт
arm_shell_wall   = 1.3;     // минимум материала вокруг входа гнезда
arm_shell_r      = 5;       // скругление контура площадки
arm_headshell_t     = 3;
arm_headshell_w     = 24;   // шире корпуса AT91: в задней части проходит гнездо
arm_headshell_reach = 32;   // от торца трубки до иглы по оси головки
arm_wire_exit_d     = 4.5;
arm_wire_hole_d     = 8;    // проём в крышке под сигнальный провод

arm_hub_w   = 18;           // ступица качания (по горизонтальной оси)
arm_hub_h   = 14;
arm_hub_len = 22;
arm_pivot_screw_pilot = 2.5; // винты M3 с заточенным концом = ось качания
arm_pivot_cone_d = 3.2;      // конусные гнёзда в ступице
arm_pivot_cone_depth = 1.6;

arm_yoke_gap       = 20;    // внутренний просвет вилки
arm_yoke_upright_t = 4;
arm_yoke_upright_w = 12;
arm_yoke_bar_t     = 6;
arm_yoke_rise      = 16;    // верх стойки → горизонтальная ось качания

arm_pivot_shaft_d   = 8;    // вертикальная ось, полая (в ней провод)
arm_pivot_shaft_len = 18;
arm_pivot_clr       = 0.25;
arm_pivot_land      = 6;    // рабочие пояски вертикального подшипника
arm_pivot_relief    = 1.2;  // расширение канала между поясками — карман для смазки
arm_pivot_wire_d    = 5;

arm_pillar_od    = 18;
arm_base_flange_d = 44;
arm_base_flange_t = 4;
arm_base_scr_r    = 16;     // радиус расположения трёх крепёжных винтов
arm_base_boss_h   = 6;

arm_cw_stub_d   = 8;        // хвостовик под противовес
arm_cw_stub_len = 58;
arm_cw_d        = 28;       // противовес: стакан, засыпается дробью/гайками
arm_cw_h        = 22;
arm_cw_wall     = 2.5;
arm_cw_bore_clr = 0.3;

// Подставка ловит трубку до хомута головки: вес тонарма должен ложиться
// на саму трубку, а не на съёмную деталь и её винт.
arm_rest_dist    = 82;      // подставка тонарма: расстояние от оси стойки
arm_park_azimuth = -85;     // направление трубки в припаркованном положении
arm_rest_lift    = 5;       // на сколько подставка приподнимает трубку
arm_rest_od      = 10;      // ствол стойки
// Ложе — U-образный паз вдоль трубки со стенками до её верха: трубка
// просто ложится сверху, ничего не вдавливается (нагрузка на оси качания),
// а вбок при переноске ей деться некуда.
arm_rest_head_len = 10;     // длина ложа вдоль трубки
arm_rest_clr      = 0.25;   // боковой зазор трубки в ложе
arm_rest_floor    = 3;      // материал под трубкой
arm_rest_wall     = 3;      // стенки ложа
arm_rest_foot_d  = 26;
arm_rest_foot_t  = 4;
arm_rest_scr_dx  = 9;       // два винта крепления подставки, смещение по X

// ============================================================================
//  ПЕЧАТНЫЕ ПЛАТЫ ВНУТРИ КОРПУСА
// ============================================================================
main_pcb       = [70, 55];  // фонокорректор + УМ
main_pcb_pos   = [82, -25];
main_pcb_t     = 1.6;
pcb_hole_inset = 4;
pcb_standoff_h = 5;
pcb_standoff_d = 7;
pcb_pilot      = 2.1;       // под M2.5

// ============================================================================
//  ПРОИЗВОДНЫЕ ВЕЛИЧИНЫ (не редактировать — считаются из параметров выше)
// ============================================================================
tray_h  = case_h - cover_plate_t;       // высота поддона
inner_w = case_w - 2*wall;
inner_d = case_d - 2*wall;
inner_r = corner_r - wall;
inner_h = tray_h - floor_t;

// ---- диск и вал по высоте ----
platter_bottom_z = case_h + platter_gap;
platter_top_z    = platter_bottom_z + platter_h;
// мат лежит в утоплении, поэтому выступает над плоскостью диска не на всю
// свою толщину
record_z         = platter_top_z - platter_mat_recess + mat_t;
record_surface_z = record_z + record_t;           // рабочая плоскость
spindle_top_z    = record_surface_z + spindle_above_record;
// Ступенька 8 -> 7.1 прячется в ступице диска под матом
spindle_tip_z    = platter_top_z - platter_mat_recess;

// ---- отсек модуля вращения ----
drive_bay = [[-inner_w/2 + drive_keep_side, -inner_d/2 + drive_keep_front],
             [drive_bay_x1,                  inner_d/2 - drive_keep_back]];
drive_floor_z   = floor_t + drive_mount_boss_h;   // низ шасси модуля
drive_ceiling_z = tray_h - cover_rib_h - 1;       // под рёбрами крышки
drive_spindle_ceiling_z = tray_h - 1;             // в зоне spindle_keepout_d

// ---- тонарм ----
arm_mount_dist = arm_eff_len - arm_overhang;      // ось стойки → ось диска
arm_pivot_pos  = [platter_pos[0] + arm_mount_dist*cos(arm_azimuth),
                  platter_pos[1] + arm_mount_dist*sin(arm_azimuth)];
arm_axis_z     = record_surface_z + cart_height + arm_headshell_t + arm_tube_od/2;
arm_pillar_top_z = arm_axis_z - arm_yoke_rise;
arm_pillar_h   = arm_pillar_top_z - case_h;       // высота стойки над крышкой

// Прямая трубка + развёрнутая головка. Задано: эффективная длина,
// угол разворота головки и её вылет; отсюда получаются угол между
// головкой и трубкой (alpha), угол между трубкой и линией «ось–игла»
// (delta) и длина трубки от оси качания.
arm_headshell_angle = atan2(arm_eff_len*sin(arm_offset_angle),
                            arm_eff_len*cos(arm_offset_angle) - arm_headshell_reach);
arm_tube_delta   = arm_headshell_angle - arm_offset_angle;
arm_tube_reach   = arm_eff_len*cos(arm_tube_delta)
                   - arm_headshell_reach*cos(arm_headshell_angle);
arm_stylus_local = [arm_eff_len*cos(arm_tube_delta), -arm_eff_len*sin(arm_tube_delta)];
arm_pin_len      = arm_pivot_shaft_len + arm_yoke_bar_t;
arm_cw_center_dist = arm_cw_stub_len - arm_cw_h/2 - 2;  // центр противовеса от оси
arm_socket_d    = arm_tube_od + arm_joint_clr;
arm_joint_scr_z = arm_tube_od/2 - arm_joint_flat_d;   // уровень лыски на трубке
arm_shell_pad_z = arm_joint_scr_z + arm_shell_pad_t;  // верх нароста от оси
// Контур площадки: от заднего края до кромки у иглы
arm_shell_slot_x = arm_headshell_reach - cart_stylus_to_holes;   // линия крепежа
arm_shell_front  = arm_shell_slot_x + cart_slot_len/2 + 5;
arm_shell_bot    = -(arm_tube_od/2 + arm_headshell_t);

// Точка края входного отверстия гнезда в системе площадки: вход — плоскость
// перпендикулярно трубке, поэтому край отверстия лежит на ней в направлении,
// поперечном трубке (s = +-1).
function arm_shell_mouth_pt(s) =
    let (y = s*(arm_socket_d/2 + arm_shell_wall))
    [-arm_joint_len*cos(arm_headshell_angle) - y*sin(arm_headshell_angle),
     -arm_joint_len*sin(arm_headshell_angle) + y*cos(arm_headshell_angle)];

// Лежит ли точка внутри скруглённого прямоугольника контура площадки
function arm_shell_covers(p) =
    norm([p[0] - min(max(p[0], -arm_shell_rear + arm_shell_r),
                     arm_shell_front - arm_shell_r),
          p[1] - min(max(p[1], -arm_headshell_w/2 + arm_shell_r),
                     arm_headshell_w/2 - arm_shell_r)]) <= arm_shell_r;

for (s = [-1, 1])
    assert(arm_shell_covers(arm_shell_mouth_pt(s)),
           "Вход гнезда трубки выходит за контур площадки: увеличьте arm_headshell_w / arm_shell_rear или уменьшите arm_joint_len");
assert(arm_shell_pad_z - arm_socket_d/2 > 1.8,
       "Тонкая стенка над гнездом трубки: увеличьте arm_shell_pad_t");
assert(-arm_shell_bot - arm_socket_d/2 > 1.8,
       "Гнездо трубки прорежет площадку снизу: увеличьте arm_headshell_t");
assert(arm_shell_pad_x < arm_shell_slot_x - cart_slot_len/2 - 5,
       "Нарост площадки налезает на пазы крепления головки");
assert(arm_shell_pad_x > arm_socket_d/2*sin(arm_headshell_angle) + 2,
       "Нарост кончается раньше дна гнезда трубки: увеличьте arm_shell_pad_x");
// Передний край нароста должен перекрывать и канал провода — иначе в стенке
// вылезает отверстие во внутреннюю полость.
assert(arm_shell_pad_x > arm_wire_chan_fwd*cos(arm_headshell_angle)
                         + arm_wire_exit_d/2*sin(arm_headshell_angle) + 1.5,
       "Канал провода выходит за передний край нароста: увеличьте arm_shell_pad_x");

arm_rest_pos   = [arm_pivot_pos[0] + arm_rest_dist*cos(arm_park_azimuth),
                  arm_pivot_pos[1] + arm_rest_dist*sin(arm_park_azimuth)];
// Ложе подставки (высоты абсолютные). Ось уложенной трубки — ровно на
// arm_rest_lift выше рабочего уровня; верх стенок — по верху трубки.
arm_rest_tube_z   = arm_axis_z + arm_rest_lift;
arm_rest_chan_w   = arm_tube_od + 2*arm_rest_clr;
arm_rest_top_z    = arm_rest_tube_z + arm_tube_od/2;
arm_rest_head_bot = arm_rest_tube_z - arm_tube_od/2 - arm_rest_floor;
arm_rest_head_hw  = arm_rest_chan_w/2 + arm_rest_wall;     // полуширина головы

// Три винта крепления стойки тонарма (в системе корпуса)
arm_base_scr_pos = [ for (a = [90, 210, 330])
                     [arm_pivot_pos[0] + arm_base_scr_r*cos(a),
                      arm_pivot_pos[1] + arm_base_scr_r*sin(a)] ];
assert(arm_rest_dist + arm_rest_head_len/2 < arm_tube_reach - arm_joint_len - 1,
       "Ложе подставки попадает на нарост головки: уменьшите arm_rest_dist");
assert(arm_rest_head_bot - case_h > arm_rest_foot_t + 8 + 4,
       "Ложе подставки слишком низко: не остаётся ствола под переход к голове");
assert(norm([arm_rest_pos[0] - platter_pos[0], arm_rest_pos[1] - platter_pos[1]])
       > platter_d/2 + arm_rest_foot_d/2 + 2,
       "Подставка тонарма налезает на диск: правьте arm_rest_dist/arm_park_azimuth");

// Два винта крепления подставки тонарма
arm_rest_scr_pos = [ for (s = [-1, 1])
                     [arm_rest_pos[0] + s*arm_rest_scr_dx*cos(arm_park_azimuth + 90),
                      arm_rest_pos[1] + s*arm_rest_scr_dx*sin(arm_park_azimuth + 90)] ];

// ---- панель управления ----
panel_win_top  = panel_z + panel_h/2;
panel_win_bot  = panel_z - panel_h/2;
panel_plate    = [panel_w + 2*panel_flange, panel_h + 2*panel_flange];
panel_pad_x    = panel_w + 2*panel_pad_w;
panel_pad_z0   = max(floor_t, panel_win_bot - panel_pad_w);
panel_pad_z1   = min(tray_h - cover_lip_h - 1, panel_win_top + panel_pad_w);
panel_scr_pos  = [ for (sx = [-1, 1], sz = [-1, 1])
                   [sx*(panel_w/2 + panel_scr_off), panel_z + sz*(panel_h/2 + panel_scr_off)] ];

// ---- стойки крышки ----
// Стойки идут от дна поддона до его кромки; по углам они попадают точно
// в центры скруглений, поэтому «врастают» в стенки.
// По серединам длинных стенок — ещё по две точки, мимо окна панели.
case_screw_pos = concat(
    [ for (sx = [-1, 1], sy = [-1, 1])
      [sx*(case_w/2 - corner_r), sy*(case_d/2 - corner_r)] ],
    [ for (sx = [-1, 1], sy = [-1, 1])
      [sx*(panel_w/2 + 14), sy*(case_d/2 - corner_r)] ]
);

// ---- платы ----
main_pcb_hole_pos = [ for (sx = [-1, 1], sy = [-1, 1])
                      [main_pcb_pos[0] + sx*(main_pcb[0]/2 - pcb_hole_inset),
                       main_pcb_pos[1] + sy*(main_pcb[1]/2 - pcb_hole_inset)] ];

// ============================================================================
//  ФУНКЦИИ
// ============================================================================
// Азимут линии «ось качания → игла» при игле на радиусе r от оси диска.
// Знак выбран так, чтобы тонарм работал с правой стороны диска.
function arm_azimuth_at(r) =
    atan2(platter_pos[1] - arm_pivot_pos[1], platter_pos[0] - arm_pivot_pos[0])
    + acos((arm_eff_len*arm_eff_len + arm_mount_dist*arm_mount_dist - r*r)
           / (2*arm_eff_len*arm_mount_dist));

// Азимут самой трубки (она повёрнута относительно линии «ось–игла» на delta)
function arm_tube_azimuth_at(r) = arm_azimuth_at(r) + arm_tube_delta;

// Положение центра противовеса при игле на радиусе r (он позади оси качания)
function arm_cw_pos_at(r) =
    [arm_pivot_pos[0] - arm_cw_center_dist*cos(arm_tube_azimuth_at(r)),
     arm_pivot_pos[1] - arm_cw_center_dist*sin(arm_tube_azimuth_at(r))];

// Погрешность тангенциальности тонарма на радиусе r, градусы
function arm_tracking_error(r) =
    acos((arm_eff_len*arm_eff_len + r*r - arm_mount_dist*arm_mount_dist)
         / (2*arm_eff_len*r)) - (90 - arm_offset_angle);

// ============================================================================
//  ПРОВЕРКИ КОМПОНОВКИ
// ============================================================================
assert(corner_r > wall, "Скругление боковых рёбер должно быть больше толщины стенки");
assert(platter_d/2 + 5 < min(case_w, case_d)/2 - wall, "Диск не влезает в корпус");
for (p = drive_mount_pos)
    assert(p[0] - drive_mount_boss_d/2 >= drive_bay[0][0] && p[0] + drive_mount_boss_d/2 <= drive_bay[1][0]
           && p[1] - drive_mount_boss_d/2 >= drive_bay[0][1] && p[1] + drive_mount_boss_d/2 <= drive_bay[1][1],
           "Бобышка модуля вращения вне отсека drive_bay");
assert(drive_bay[1][0] < main_pcb_pos[0] - main_pcb[0]/2, "Отсек модуля вращения налезает на плату УМ");
assert(spindle_keepout_d > cover_spindle_hole_d + 4, "Зона без рёбер вокруг вала уже проёма в крышке");
assert(arm_yoke_rise >= arm_yoke_bar_t + arm_hub_h/2 + 2, "Вилка тонарма упирается в ступицу");
assert(arm_mount_dist > platter_d/2 + arm_base_flange_d/2, "Стойка тонарма попадает под диск");
assert(panel_pad_z1 > panel_win_top + panel_flange, "Рамка панели не влезает по высоте");
// Противовес должен оставаться в габарите корпуса на всём ходе тонарма
for (r = [arm_groove_r_in, arm_groove_r_out]) {
    assert(abs(arm_cw_pos_at(r)[0]) + arm_cw_d/2 < case_w/2 - wall,
           "Противовес выходит за боковую стенку: уменьшите arm_azimuth");
    assert(abs(arm_cw_pos_at(r)[1]) + arm_cw_d/2 < case_d/2 - wall,
           "Противовес выходит за заднюю стенку: уменьшите arm_azimuth");
}

echo(str("== Проигрыватель: сводка =="));
echo(str("Габарит корпуса: ", case_w, " x ", case_d, " x ", case_h, " мм"));
echo(str("Верх диска Z=", platter_top_z, ", рабочая плоскость пластинки Z=", record_surface_z));
echo(str("Отсек модуля вращения: X ", drive_bay[0][0], "..", drive_bay[1][0],
         ", Y ", drive_bay[0][1], "..", drive_bay[1][1], ", Z ", drive_floor_z, "..", drive_ceiling_z));
echo(str("Тонарм: L=", arm_eff_len, ", вынос=", arm_overhang, ", разворот=", arm_offset_angle,
         ", ось качания Z=", arm_axis_z));
echo(str("Погрешность тонарма на r=", arm_groove_r_out, ": ", arm_tracking_error(arm_groove_r_out),
         " град, на r=", arm_groove_r_in, ": ", arm_tracking_error(arm_groove_r_in), " град"));
