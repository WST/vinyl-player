# Сборка STL всех деталей: make -j4
# Отдельная деталь:        make build/platter.stl
# Быстрая проверка всех моделей на ошибки и незамкнутость: make check

OPENSCAD ?= openscad
SRC   := $(wildcard parts/*.scad)
NAMES := $(basename $(notdir $(SRC)))
STL   := $(addprefix build/,$(addsuffix .stl,$(NAMES)))
DEPS  := params.scad lib/common.scad

.PHONY: all check clean list
.DELETE_ON_ERROR:

all: $(STL)

build/%.stl: parts/%.scad $(DEPS)
	@mkdir -p build
	$(OPENSCAD) -o $@ $<

# Рендерит всё и падает, если OpenSCAD выдал ошибку, предупреждение
# или пожаловался на незамкнутую модель
check:
	@mkdir -p build
	@fail=0; for f in $(SRC) assembly.scad; do \
	  out=$$($(OPENSCAD) -o build/check.stl $$f 2>&1); \
	  if echo "$$out" | grep -qiE 'error|warning'; then \
	    echo "ПРОБЛЕМА: $$f"; echo "$$out" | grep -iE 'error|warning'; fail=1; \
	  else echo "ok: $$f"; fi; \
	done; rm -f build/check.stl; exit $$fail

list:
	@echo $(NAMES) | tr ' ' '\n'

clean:
	rm -rf build
