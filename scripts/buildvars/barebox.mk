include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

BAREBOX_ARGS= \
	ARCH="${BUILDVAR_ARCH}" \
	CC="${BUILDVAR_KERNEL_CC}" \
	LD="${BUILDVAR_KERNEL_LD}" \
	AR="${BUILDVAR_KERNEL_AR}" \
	CROSS_COMPILE="${BUILDVAR_TARGET_PREFIX}" \
	PKG_CONFIG_LIBDIR='${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib/pkgconfig' \

%:
	${MAKE} ${BAREBOX_ARGS} $@

.generic-build:
	${MAKE} ${BAREBOX_ARGS}

## required for building 'menuconfig' with correct libncurses
menuconfig nconfig gconfig:	export PKG_CONFIG_LIBDIR=${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib/pkgconfig
menuconfig nconfig gconfig:	export LD_LIBRARY_PATH=${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib
