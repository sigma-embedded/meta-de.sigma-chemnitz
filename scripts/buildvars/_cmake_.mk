include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

.DEFAULT_GOAL = cmake-install

CMAKE ?= cmake
CMAKE_MAKE ?= ninja
CMAKE_ARGS = \
	${BUILDVAR_OECMAKE_ARGS} \
	${BUILDVAR_EXTRA_OECMAKE} \

cmake-setup:
	${CMAKE} ${BUILDVAR_OECMAKE_GENERATOR_ARGS} ${CMAKE_ARGS} '$S'

cmake-build:
	${CMAKE_MAKE}

cmake-%:
	${CMAKE_MAKE} $*
