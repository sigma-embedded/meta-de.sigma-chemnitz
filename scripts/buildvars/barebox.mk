include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

BAREBOX_ARGS= \
	ARCH="${BUILDVAR_ARCH}" \
	CC="${BUILDVAR_KERNEL_CC}" \
	LD="${BUILDVAR_KERNEL_LD}" \
	AR="${BUILDVAR_KERNEL_AR}" \
	HOSTCPP='${BUILDVAR_BUILD_CPP}' \
	HOSTCPPFLAGS='${BUILDVAR_BUILD_CPPFLAGS}' \
	HOSTCC='${BUILDVAR_BUILD_CC}' \
	HOSTCFLAGS='${BUILDVAR_BUILD_CFLAGS}' \
	HOSTCXX='${BUILDVAR_BUILD_CXX}' \
	HOSTCXXFLAGS='${BUILDVAR_BUILD_CXXFLAGS}' \
	HOSTLD='${BUILDVAR_BUILD_LD}' \
	HOSTLDFLAGS='${BUILDVAR_BUILD_LDFLAGS}' \
	CROSS_COMPILE="${BUILDVAR_TARGET_PREFIX}" \
	CROSS_PKG_CONFIG='${BUILDVAR_X_CROSS_PKG_CONFIG}' \
        PKG_CONFIG='${BUILDVAR_X_PKG_CONFIG}' \

%:
	${MAKE} ${BAREBOX_ARGS} $@

.generic-build:
	${MAKE} ${BAREBOX_ARGS}

## required for building 'menuconfig' with correct libncurses
menuconfig nconfig gconfig:	export PKG_CONFIG_LIBDIR=${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib/pkgconfig
menuconfig nconfig gconfig:	export LD_LIBRARY_PATH=${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib
