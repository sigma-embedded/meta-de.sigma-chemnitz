include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

BUILD_FLAGS = \
	CROSS_COMPILE='${BUILDVAR_TARGET_PREFIX}' \
	CC='$(if ${BUILDVAR_UBOOT_CC},${BUILDVAR_UBOOT_CC},${BUILDVAR_KERNEL_CC})' \
	LD='$(if ${BUILDVAR_UBOOT_LD},${BUILDVAR_UBOOT_LD},${BUILDVAR_KERNEL_LD})' \
	HOSTCC='${BUILDVAR_BUILD_CC} ${BUILDVAR_BUILD_CFLAGS} ${BUILDVAR_BUILD_LDFLAGS}' \

%:
	${MAKE} ${BUILD_FLAGS} $@

check-syntax:
	@${MAKE} -s ${BUILD_FLAGS} -f flymake.mk

## required for building 'menuconfig' with correct libncurses
menuconfig nconfig gconfig:	export LD_LIBRARY_PATH=${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib
