// ============================================================================
//  МОДУЛЬ ВРАЩЕНИЯ — ПАРАМЕТРЫ
//
//  Самостоятельный узел («плагин»): шасси с двумя стальными валами на
//  подшипниках 608ZZ, двухступенчатая пассиковая редукция и двигатель
//  RF-300C-14270. Ставится в поддон на бобышки drive_mount_pos.
//  Поддон и крышка от этого файла не зависят — они видят только интерфейс
//  в ../params.scad (отсек, точки крепления, потолок, ось и диаметр вала).
//
//  Кинематика:
//    двигатель, заводское колесо --пассик 1--> большое колесо промвала
//    промвал, сам стальной вал как шкив --пассик 2--> колесо вала диска
//
//  Система координат — общая для всего проекта (см. ../params.scad).
// ============================================================================

include <../params.scad>

// ------------------------------------------------------------ двигатель ----
// RF-300C-14270 (Mabuchi): 1.9 В ном. (0.5...4 В), ~3500 об/мин без
// нагрузки, ~2700 под нагрузкой. Колесо под пассик стоит с завода.
motor_d         = 24.5;
motor_h         = 13;       // корпус без колеса
motor_full_h    = 16.35;    // вместе с колесом
motor_groove_d  = 4.3;      // дно канавки заводского колеса
// Середина канавки над донцем двигателя — ОЦЕНКА, уточнить штангенциркулем.
// От неё зависит только толщина дна держателя двигателя.
motor_groove_z  = 14.7;
motor_pulley_od = 6.5;      // только для болванки
motor_rpm       = 3000;     // рабочие обороты, под них считается редукция
motor_bump_d    = 8;        // выемка под выступ подшипника на донце
motor_bump_h    = 1.5;
motor_wire_angle = -60;     // вырез под провода (0 — направление «от промвала»)

// --------------------------------------------------- подшипники 608ZZ ------
brg_od = 22;
brg_id = 8;
brg_w  = 7;
brg_inner_ring_d = 11.5;    // упор только во внутреннее кольцо
brg_outer_ring_d = 19.6;    // упор только в наружное кольцо
brg_seat_clr     = 0.15;    // посадка в печатное гнездо — подобрать под принтер

// --------------------------------------------------------------- пассики ---
// Квадратные 1.2 мм из ремнабора. Маркировка набора — «сложенная длина»,
// то есть половина окружности: самый большой «135» — это ~270 мм по кругу.
belt_t          = 1.2;
belt_max_folded = 135;
belt_stretch    = 0.07;     // натяг: пассик короче своего пути на 7 %
belt_min_wrap   = 100;      // минимальный охват малого шкива, град
belt_side_clr   = 0.6;      // свободный ход пассика по высоте

// ----------------------------------------------------------- компоновка ----
// Промвал стоит за осью диска: спереди и слева отсек упирается в резерв
// под плату управления и динамик. Двигатель — правее промвала.
idler_dist      = 58;       // межосевое: вал диска -> промвал
idler_angle     = 120;      // направление от оси диска, град
motor_dist      = 55;       // межосевое: промвал -> двигатель
motor_angle     = 0;        // направление от промвала
idler_pulley_pd = 62;       // большое колесо промвала, по средней линии пассика
// Рабочий участок промвала под пассиком 2. Если проточить его тоньше,
// колесо на валу диска пересчитается меньше.
capstan_d       = spindle_d;

// --------------------------------------------------------------- шасси -----
chassis_t     = 3;          // плита
chassis_r     = 6;          // скругление углов плиты
chassis_ear   = 7;          // поле плиты вокруг бобышек поддона
chassis_rib_t = 2.4;        // рёбра жёсткости
chassis_rib_h = 4;
tower_wall    = 3;          // стенка вокруг подшипника
tower_mid_t   = 1;          // минимальная перемычка между гнёздами
tower_gusset  = 9;          // косынки у основания башен

// ------------------------------------------------- держатель двигателя -----
holder_boss_d    = 8;       // бобышки шасси под держатель
holder_boss_h    = 3;
holder_wall      = 2.4;     // стенка стакана
holder_cup_h     = 9;       // сколько стакан охватывает корпус двигателя
holder_clr       = 0.4;
holder_foot_span = 46;      // между пазами крепления
holder_slot_len  = 8;       // ход регулировки натяжения пассика 1
holder_ear       = 8;       // уши стяжного винта

// ------------------------------------------- плата регулятора оборотов -----
// Вплотную к двигателю, напротив выхода его проводов: провода мотора
// короткие и меньше наводят. Не под колесом вала диска — подстроечник
// доступен сверху при снятой крышке.
reg_pcb        = [20, 40];      // габарит платы по X и Y
reg_pcb_pos    = [24, 1];       // центр платы
reg_pcb_t      = 1.6;
// Крепёжные отверстия платы от её центра — поправить под реальную плату
reg_pcb_holes  = [[-7, -17], [7, -17], [-7, 17], [7, 17]];
reg_standoff_d = 6;
reg_solder_clr = 2.5;           // под пайкой выводов над рёбрами шасси
reg_pad_margin = 3;             // поле плиты шасси вокруг платы

// --------------------------------------------------------------- шкивы -----
pulley_t        = 4;        // высота обода
pulley_groove_h = 1.0;      // глубина канавки
pulley_rim_w    = 4;        // ширина обода
pulley_web_t    = 2;
pulley_hub_d    = 16;
pulley_clr      = 1.5;      // по высоте между колёсами, перекрывающимися в плане
rod_bore_clr    = 0.2;      // посадка колёс на вал (держит стопорный винт)
hub_set_h       = 6.2;      // участок ступицы под стопорный винт M3
thrust_ring_h   = 0.5;      // упорный поясок ступицы по внутреннему кольцу
spacer_t        = 1.2;      // шайба между колесом вала диска и подшипником
cap_h           = 4.1;      // колпачок-бортик на верхнем конце промвала
cap_d           = 13;
cap_fit         = 0;        // натяг посадки колпачка (печатное отверстие и так «садится»)
// Упор вала вверх: кольцо из нескольких слоёв термоусадки на валу под
// нижним подшипником, упирается только во внутреннее кольцо
stop_ring_h     = 3;
stop_ring_d     = 10;
rod_bottom_gap  = stop_ring_h + 0.5;   // насколько валы выступают под шасси

// ============================================================================
//  ПРОИЗВОДНЫЕ (не редактировать)
// ============================================================================
function polar(c, r, a) = [c[0] + r*cos(a), c[1] + r*sin(a)];

spindle_pos = platter_pos;
idler_pos   = polar(spindle_pos, idler_dist, idler_angle);
motor_pos   = polar(idler_pos, motor_dist, motor_angle);

// ---- редукция (диаметры — по средней линии пассика) ----
motor_pd    = motor_groove_d + belt_t;
capstan_pd  = capstan_d + belt_t;
ratio_total = motor_rpm / platter_rpm;
ratio1      = idler_pulley_pd / motor_pd;
ratio2      = ratio_total / ratio1;
spindle_pulley_pd = capstan_pd * ratio2;
idler_rpm   = motor_rpm / ratio1;

function pulley_od(pd) = pd - belt_t + 2*pulley_groove_h;
idler_pulley_od   = pulley_od(idler_pulley_pd);
spindle_pulley_od = pulley_od(spindle_pulley_pd);

// ---- высоты ----
// Считаются сверху вниз: всё упирается в рёбра крышки (drive_ceiling_z).
chassis_z0 = drive_floor_z;
chassis_z1 = chassis_z0 + chassis_t;

idler_rod_top_z   = drive_ceiling_z - 0.5;
cap_z0            = drive_ceiling_z - cap_h;
belt2_z           = cap_z0 - belt_side_clr - belt_t/2;    // плоскость пассика 2
spindle_pulley_z0 = belt2_z - pulley_t/2;
spindle_tower_top = spindle_pulley_z0 - spacer_t;
spindle_hub_top   = drive_spindle_ceiling_z;
spindle_set_z     = (spindle_pulley_z0 + pulley_t + spindle_hub_top)/2;

idler_pulley_z1   = spindle_pulley_z0 - pulley_clr;       // верх колеса промвала
idler_pulley_z0   = idler_pulley_z1 - pulley_t;
belt1_z           = idler_pulley_z1 - pulley_t/2;         // плоскость пассика 1
idler_tower_top   = idler_pulley_z0 - hub_set_h - thrust_ring_h;
idler_set_z       = idler_tower_top + thrust_ring_h + hub_set_h/2;

motor_base_z  = belt1_z - motor_groove_z;
holder_z0     = chassis_z1 + holder_boss_h;
holder_base_t = motor_base_z - holder_z0;

rod_bottom_z    = chassis_z0 - rod_bottom_gap;
spindle_rod_len = spindle_top_z - rod_bottom_z;
spindle_tip_len = spindle_top_z - spindle_tip_z;
idler_rod_len   = idler_rod_top_z - rod_bottom_z;

// ---- шасси ----
tower_od = brg_od + 2*tower_wall;
seat_d   = brg_od + brg_seat_clr;
chassis_x0 = min([for (p = drive_mount_pos) p[0]]) - chassis_ear;
chassis_x1 = max([for (p = drive_mount_pos) p[0]]) + chassis_ear;
chassis_y0 = min([for (p = drive_mount_pos) p[1]]) - chassis_ear;
chassis_y1 = max([for (p = drive_mount_pos) p[1]]) + chassis_ear;

// ---- держатель двигателя ----
holder_cup_id = motor_d + holder_clr;
holder_cup_od = holder_cup_id + 2*holder_wall;
holder_boss_pos = [ for (s = [-1, 1]) polar(motor_pos, holder_foot_span/2, motor_angle + 90*s) ];
holder_foot_d = holder_boss_d + 4;
// Лапа при сдвиге держателя на весь ход паза уходит от центра на slot_len
holder_keepout_r = norm([holder_slot_len, holder_foot_span/2]) + holder_foot_d/2 + 1;

// ---- плата регулятора ----
reg_standoff_h = chassis_rib_h + reg_solder_clr;   // выше рёбер шасси
reg_pcb_z      = chassis_z1 + reg_standoff_h;      // низ платы
reg_pad_x0 = reg_pcb_pos[0] - reg_pcb[0]/2 - reg_pad_margin;
reg_pad_x1 = reg_pcb_pos[0] + reg_pcb[0]/2 + reg_pad_margin;
reg_pad_y0 = reg_pcb_pos[1] - reg_pcb[1]/2 - reg_pad_margin;
reg_pad_y1 = reg_pcb_pos[1] + reg_pcb[1]/2 + reg_pad_margin;
reg_hole_pos = [ for (h = reg_pcb_holes) reg_pcb_pos + h ];

// Расстояние от точки до прямоугольника платы в плане
function reg_pcb_dist(p) =
    norm([max(abs(p[0] - reg_pcb_pos[0]) - reg_pcb[0]/2, 0),
          max(abs(p[1] - reg_pcb_pos[1]) - reg_pcb[1]/2, 0)]);

// ---- пассики ----
// Путь открытого пассика по средней линии; d1 > d2
function belt_path(c, d1, d2) =
    2*sqrt(c*c - pow((d1 - d2)/2, 2)) + PI*(d1 + d2)/2
    + (d1 - d2)*asin((d1 - d2)/(2*c))*PI/180;
// Угол охвата малого шкива, град
function belt_wrap(c, d1, d2) = 180 - 2*asin((d1 - d2)/(2*c));
// Какой пассик брать: сложенная длина (полупериметр) с учётом натяга
function belt_folded(path) = path*(1 - belt_stretch)/2;

// Две ветви открытого пассика (отрезки касательных) между окружностями
function belt_strands(a, ra, b, rb) =
    let (d = norm(b - a), u = (b - a)/d, n = [-u[1], u[0]],
         s = (ra - rb)/d, c = sqrt(1 - s*s))
    [ for (k = [-1, 1]) let (m = s*u + k*c*n) [a + ra*m, b + rb*m] ];

function seg_dist(p, a, b) =
    let (ab = b - a, t = max(0, min(1, ((p - a)*ab)/(ab*ab))))
    norm(p - (a + t*ab));

belt1_path = belt_path(motor_dist, idler_pulley_pd, motor_pd);
belt2_path = belt_path(idler_dist, spindle_pulley_pd, capstan_pd);
belt1_wrap = belt_wrap(motor_dist, idler_pulley_pd, motor_pd);
belt2_wrap = belt_wrap(idler_dist, spindle_pulley_pd, capstan_pd);
belt1_strands = belt_strands(idler_pos, idler_pulley_pd/2, motor_pos, motor_pd/2);

// Помещается ли круг (центр, радиус) в отсек модуля
function in_bay(c, r) =
    c[0] - r >= drive_bay[0][0] && c[0] + r <= drive_bay[1][0] &&
    c[1] - r >= drive_bay[0][1] && c[1] + r <= drive_bay[1][1];

// ============================================================================
//  ПРОВЕРКИ
// ============================================================================
// -- в отсеке
assert(chassis_x0 >= drive_bay[0][0] && chassis_x1 <= drive_bay[1][0] &&
       chassis_y0 >= drive_bay[0][1] && chassis_y1 <= drive_bay[1][1],
       "Шасси модуля вылезает из отсека drive_bay");
assert(in_bay(spindle_pos, spindle_pulley_od/2), "Колесо вала диска вылезает из отсека");
assert(in_bay(idler_pos, idler_pulley_od/2), "Колесо промвала вылезает из отсека: правьте idler_angle/idler_dist");
assert(in_bay(motor_pos, holder_keepout_r - 3), "Держатель двигателя вылезает из отсека: правьте motor_angle/motor_dist");
for (p = [spindle_pos, idler_pos, motor_pos])
    assert(p[0] > chassis_x0 + tower_od/2 && p[0] < chassis_x1 - tower_od/2 &&
           p[1] > chassis_y0 + tower_od/2 && p[1] < chassis_y1 - tower_od/2,
           "Узел модуля вне плиты шасси: правьте drive_mount_pos в ../params.scad или компоновку");

// -- по высоте
assert(spindle_hub_top - spindle_set_z > 2.5, "Мало ступицы над колесом вала диска под стопорный винт");
assert(pulley_hub_d < spindle_keepout_d - 4, "Ступица колеса вала диска шире зоны без рёбер крышки");
assert(spindle_tower_top - brg_w - (chassis_z0 + brg_w) >= tower_mid_t,
       "Подшипники вала диска не помещаются в башню");
assert(idler_tower_top - brg_w - (chassis_z0 + brg_w) >= tower_mid_t,
       "Подшипники промвала не помещаются в башню: опустите шасси или уменьшите hub_set_h");
assert(holder_base_t >= motor_bump_h + 1.5,
       "Двигатель не помещается под плоскость пассика 1: проверьте motor_groove_z");
assert(idler_rod_top_z - cap_z0 >= 3, "Колпачок промвала слишком мало сидит на валу");
assert(rod_bottom_z > floor_t + 1, "Валы упираются в дно поддона");
assert(stop_ring_d < brg_inner_ring_d, "Упорное кольцо задевает наружное кольцо подшипника");
assert(motor_base_z + motor_full_h < spindle_pulley_z0 - 0.5, "Колесо двигателя задевает колесо вала диска");

// -- в плане
assert(idler_dist > idler_pulley_od/2 + tower_od/2 + 1, "Колесо промвала задевает башню вала диска");
assert(idler_dist > spindle_pulley_od/2 + cap_d/2 + 1, "Колесо вала диска задевает колпачок промвала");
assert(motor_dist > idler_pulley_od/2 + motor_d/2 + 1, "Двигатель задевает колесо промвала");
assert(norm(motor_pos - spindle_pos) > holder_keepout_r + tower_od/2, "Держатель двигателя задевает башню вала диска");
assert(motor_dist > holder_keepout_r + tower_od/2, "Держатель двигателя задевает башню промвала");
for (s = belt1_strands)
    assert(seg_dist(spindle_pos, s[0], s[1]) > tower_od/2 + belt_t + 1,
           "Пассик 1 трётся о башню вала диска: правьте motor_angle");

// -- плата регулятора
assert(reg_pad_x0 >= drive_bay[0][0] && reg_pad_x1 <= drive_bay[1][0] &&
       reg_pad_y0 >= drive_bay[0][1] && reg_pad_y1 <= drive_bay[1][1],
       "Плата регулятора вылезает из отсека: правьте reg_pcb_pos");
assert(reg_pcb_dist(spindle_pos) > spindle_pulley_od/2 + 1,
       "Плата регулятора под колесом вала диска — к ней не подлезть сверху");
assert(reg_pcb_dist(motor_pos) > holder_keepout_r - 2,
       "Плата регулятора мешает ходу держателя двигателя");
for (h = reg_pcb_holes)
    assert(abs(h[0]) + reg_standoff_d/2 <= reg_pcb[0]/2 + 1 && abs(h[1]) + reg_standoff_d/2 <= reg_pcb[1]/2 + 1,
           "Стойка платы регулятора вылезает за плату: правьте reg_pcb_holes");

// -- пассики
assert(belt1_wrap >= belt_min_wrap, "Малый охват шкива двигателя: увеличьте motor_dist");
assert(belt2_wrap >= belt_min_wrap, "Малый охват промвала: увеличьте idler_dist");
assert(belt_folded(belt1_path) <= belt_max_folded, "Пассик 1 длиннее самого большого из набора");
assert(belt_folded(belt2_path) <= belt_max_folded, "Пассик 2 длиннее самого большого из набора");

function r1(x) = round(x*10)/10;
echo(str("== Модуль вращения =="));
echo(str("Редукция: ", r1(ratio1), " x ", r1(ratio2), " = ", r1(ratio_total),
         "; двигатель ", motor_rpm, " -> промвал ", r1(idler_rpm), " -> диск ", r1(platter_rpm), " об/мин"));
echo(str("Для 45 об/мин двигателю нужно ", round(45*ratio_total), " об/мин"));
echo(str("Колёса: промвал ", r1(idler_pulley_pd), " мм (нар. ", r1(idler_pulley_od),
         "), вал диска ", r1(spindle_pulley_pd), " мм (нар. ", r1(spindle_pulley_od), ")"));
echo(str("Пассик 1: межосевое ", motor_dist, ", путь ", r1(belt1_path), " мм, охват ", round(belt1_wrap),
         " град -> брать ~", round(belt_folded(belt1_path)), " по маркировке"));
echo(str("Пассик 2: межосевое ", idler_dist, ", путь ", r1(belt2_path), " мм, охват ", round(belt2_wrap),
         " град -> брать ~", round(belt_folded(belt2_path)), " по маркировке"));
echo(str("Вал диска: пруток 8 мм длиной ", r1(spindle_rod_len), ", сточить до ", spindle_tip_d,
         " верхние ", r1(spindle_tip_len), " мм"));
echo(str("Промвал: пруток 8 мм длиной ", r1(idler_rod_len)));
echo(str("Плоскости пассиков: Z=", r1(belt1_z), " и Z=", r1(belt2_z), ", дно двигателя Z=", r1(motor_base_z),
         " (дно держателя ", r1(holder_base_t), " мм)"));
echo(str("Плата регулятора ", reg_pcb[0], " x ", reg_pcb[1], ": низ Z=", r1(reg_pcb_z),
         ", до двигателя ", r1(reg_pcb_dist(motor_pos) - motor_d/2), " мм, высота деталей до ",
         r1(drive_ceiling_z - reg_pcb_z - reg_pcb_t), " мм"));
