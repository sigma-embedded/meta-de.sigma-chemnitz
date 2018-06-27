include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

BUILD_FLAGS = \
	CROSS_COMPILE='${BUILDVAR_TARGET_PREFIX}' \
	CC='${BUILDVAR_KERNEL_CC}' \
	LD='${BUILDVAR_KERNEL_LD}' \

%:
	${MAKE} ${BUILD_FLAGS} $@

check-syntax:
	@${MAKE} -s ${BUILD_FLAGS} -f flymake.mk
