// ============================================================================
//  ЛЕЙБЛ НА КРЫШКЕ — табличка с именем, клеится сверху
//
//  Текст: URW Bookman Demi Italic (жирный курсив). Ширина таблички
//  label_w, масштаб подгоняется сам. Стоит справа от диска, перед
//  подставкой тонарма — ближе к передней кромке крышки.
//
//  Печать: плашмя, сначала пластина, затем смена цвета на буквы.
// ============================================================================

include <../params.scad>

label_name     = "RetroVanadzor";
label_font     = "URW Bookman:style=Demi Italic";
label_size     = 20;
label_spacing  = 1;

module label_glyph() {
    resize([label_w - 2*label_border, 0], auto = true)
        text(label_name, size = label_size, font = label_font,
             spacing = label_spacing, halign = "center", valign = "center");
}

module label() {
    translate([label_pos[0], label_pos[1], case_h]) {
        color("white")
            linear_extrude(label_plate_h)
                offset(r = label_border) label_glyph();
        color("#000000")
            translate([0, 0, label_plate_h])
                linear_extrude(label_text_h) label_glyph();
    }
}

label();
