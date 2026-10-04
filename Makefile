# Сборка STL всех деталей: make -j4
# Отдельная деталь:        make build/platter.stl
# Только модуль вращения:  make drive
# Быстрая проверка всех моделей на ошибки и незамкнутость: make check

OPENSCAD ?= openscad
SRC       := $(wildcard parts/*.scad)
DRIVE_SRC := $(wildcard drive/parts/*.scad)
STL       := $(addprefix build/,$(addsuffix .stl,$(basename $(notdir $(SRC)))))
DRIVE_STL := $(addprefix build/,$(addsuffix .stl,$(basename $(notdir $(DRIVE_SRC)))))
DEPS       := params.scad lib/common.scad
DRIVE_DEPS := $(DEPS) drive/drive_params.scad drive/drive_lib.scad

.PHONY: all drive check clean list
.DELETE_ON_ERROR:

all: $(STL) $(DRIVE_STL)

drive: $(DRIVE_STL)

build/%.stl: parts/%.scad $(DEPS)
	@mkdir -p build
	$(OPENSCAD) -o $@ $<

build/%.stl: drive/parts/%.scad $(DRIVE_DEPS)
	@mkdir -p build
	$(OPENSCAD) -o $@ $<

# Рендерит всё и падает, если OpenSCAD выдал ошибку, предупреждение
# или пожаловался на незамкнутую модель
check:
	@mkdir -p build
	@fail=0; for f in $(SRC) $(DRIVE_SRC) assembly.scad drive/drive_assembly.scad; do \
	  out=$$($(OPENSCAD) -o build/check.stl $$f 2>&1); \
	  if echo "$$out" | grep -qiE 'error|warning'; then \
	    echo "ПРОБЛЕМА: $$f"; echo "$$out" | grep -iE 'error|warning'; fail=1; \
	  else echo "ok: $$f"; fi; \
	done; rm -f build/check.stl; exit $$fail

list:
	@echo $(basename $(notdir $(SRC) $(DRIVE_SRC))) | tr ' ' '\n'

clean:
	rm -rf build
