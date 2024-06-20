include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

.DEFAULT_GOAL = meson-install

MESON_ARGS = \
	${BUILDVAR_MESONOPTS} \
	${BUILDVAR_MESON_CROSS_FILE} \


MESON ?= meson
NINJA ?= ninja
SED ?=   sed

MESON_CDB_CLEANUP = \
	-e "s!-MF \+'[^'']*'!!g"

meson-setup:
	w=; test ! -e "meson-private/cmd_line.txt" || w=--wipe; \
	${MESON} setup $$w ${MESON_ARGS} '.' '$S'

meson-build:
	${NINJA}

meson-install:
	${MESON} install

meson-cdb:
	@test -d '$S' || { echo 'source directory $$S not set or missing' >&2; exit 1; }
	@rm -f $S/compile_commands.json
	${SED} ${MESON_CDB_CLEANUP} < compile_commands.json > $S/compile_commands.json

meson-test:
	${MESON} test ${MESON_TEST_ARGS}

meson-coverage:
	${NINJA} coverage ${MESON_COVERAGE_ARGS}

meson-introspect:
	${MESON} introspect ${MESON_INTROSPECT_ARGS}

meson-devenv:
	${MESON} devenv ${MESON_DEVENV_ARGS}

meson-wrap:
	${MESON} wrap ${MESON_WRAP_ARGS}

meson-help:
	@echo "  meson-setup      [MESON_ARGS=...]"
	@echo "  meson-build"
	@echo "  meson-install"
	@echo "  meson-cdb                                ... creates compile database"
	@echo "  meson-test       [MESON_TEST_ARGS=...]"
	@echo "  meson-coverage   [MESON_COVERAGE_ARGS=...]"
	@echo "  meson-introspect [MESON_INTROSPECT_ARGS=...]"
	@echo "  meson-devenv     [MESON_DEVENV_ARGS=...]"
	@echo "  meson-wrap       [MESON_WRAP_ARGS=...]"
