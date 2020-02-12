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

meson-setup:	export PKG_CONFIG_LIBDIR=${BUILDVAR_PKG_CONFIG_LIBDIR}
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
