// ============================================================================
//  Вспомогательные модули общего назначения.
//  Подключать через use <lib/common.scad> — файл не содержит параметров
//  проекта и ни от чего не зависит.
// ============================================================================

_eps = 0.01;

// --------------------------------------------------------------------- 2D ---
// Прямоугольник со скруглёнными углами, по центру
module rrect(w, d, r) {
    rr = min(r, w/2 - _eps, d/2 - _eps);
    if (rr > 0) offset(r = rr) square([w - 2*rr, d - 2*rr], center = true);
    else square([w, d], center = true);
}

// --------------------------------------------------------------------- 3D ---
// Коробка со скруглением ТОЛЬКО вертикальных рёбер: нижние и верхние острые
module rounded_box(w, d, h, r) linear_extrude(height = h) rrect(w, d, r);

// Цилиндр с фасками на торцах (снимает «слоновью ногу» и облегчает посадку)
module chamfered_cyl(d, h, ch = 0.6, bottom = true, top = true) {
    r  = d/2;
    cb = bottom ? min(ch, h/2) : 0;
    ct = top    ? min(ch, h/2) : 0;
    if (cb <= 0 && ct <= 0) cylinder(d = d, h = h);
    else rotate_extrude(angle = 360) polygon(concat(
        [[0, 0]],
        cb > 0 ? [[r - cb, 0], [r, cb]] : [[r, 0]],
        ct > 0 ? [[r, h - ct], [r - ct, h]] : [[r, h]],
        [[0, h]]));
}

// Труба
module tube(od, id, h) difference() {
    cylinder(d = od, h = h);
    translate([0, 0, -_eps]) cylinder(d = id, h = h + 2*_eps);
}

// Сквозное отверстие, растянутое вверх-вниз для гарантированного вычитания
module thru(d, h) translate([0, 0, -_eps]) cylinder(d = d, h = h + 2*_eps);

// Потайное отверстие под саморез с конической головкой.
// Пластина занимает z = [0 .. t], головка утапливается сверху,
// саморез идёт вниз (в ответную стойку).
module countersunk_hole(free_d, head_d, t, down = 30) {
    cone_h = (head_d - free_d)/2;    // головка 90 градусов
    union() {
        translate([0, 0, -down]) cylinder(d = free_d, h = down + t - cone_h + _eps);
        translate([0, 0, t - cone_h]) cylinder(d1 = free_d, d2 = head_d, h = cone_h);
    }
}

// Паз (щелевое отверстие) длиной len по X, сквозной по высоте h
module slot(len, d, h) hull() for (s = [-1, 1])
    translate([s*(len - d)/2, 0, 0]) cylinder(d = d, h = h);

// Стойка под саморез: цилиндр с пилотным отверстием сверху.
// Снизу фаски нет — стойка растёт из дна детали.
module screw_boss(od, h, pilot_d, pilot_depth, ch = 0.6) difference() {
    chamfered_cyl(od, h, ch = ch, bottom = false, top = true);
    translate([0, 0, h - pilot_depth]) cylinder(d = pilot_d, h = pilot_depth + _eps);
}

// Треугольная косынка в плоскости XZ (катеты l по X и h по Z), толщина t по Y
module gusset(l, h, t) translate([0, -t/2, 0]) linear_extrude(height = t)
    polygon([[0, 0], [l, 0], [0, h]]);

// Конусное гнездо под заточенный винт-ось (ось Z вниз от z=0)
module cone_seat(d, depth) translate([0, 0, -depth])
    cylinder(d1 = 0.2, d2 = d, h = depth + _eps);

// Канавка под круглый пассик: тор, вычитаемый из обода
module belt_groove(pulley_d, groove_r) rotate_extrude(angle = 360)
    translate([pulley_d/2, 0]) circle(r = groove_r);

// Сетка облегчающих отверстий по кругу
module radial_holes(n, r, d, h) for (i = [0 : n - 1])
    rotate([0, 0, i*360/n]) translate([r, 0, 0]) thru(d, h);
