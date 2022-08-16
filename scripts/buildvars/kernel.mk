include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk
include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/__image_rootfs.mk

IMAGE_ROOTFS ?= ${BUILDVAR_IMAGE_ROOTFS}

ifneq (${HAVE_NFSROOT},)
KERNEL_NFSSERVER ?= $(shell getent ahostsv4 '${BUILDVAR_KERNEL_NFSSERVER}' | sed '1s/[[:space:]].*//p;d')
KERNEL_NFSOPTS ?= v3,tcp,nolock,rsize=32768,wsize=32768
KERNEL_NFSROOT ?= ${KERNEL_NFSSERVER}:${IMAGE_ROOTFS},${KERNEL_NFSOPTS}${CFG_NFSOPTS_EXTRA}
endif

INSTALL_MOD_PATH ?= ${IMAGE_ROOTFS}

KERNEL_ARGS= \
	${BUILDVAR_EXTRA_OEMAKE} \
	MACHINE= \
	ARCH="${BUILDVAR_ARCH}" \
	CC="${BUILDVAR_KERNEL_CC}" \
	LD="${BUILDVAR_KERNEL_LD}" \
	AR="${BUILDVAR_KERNEL_AR}" \
	CROSS_COMPILE="${BUILDVAR_CROSS_COMPILE}" \
	INSTALL_MOD_PATH='${INSTALL_MOD_PATH}' \
	DEPMOD='${BUILDVAR_STAGING_DIR_NATIVE}/usr/bin/depmod' \
	$(if ${KERNEL_NFSROOT},DEFAULT_NFSROOT='${KERNEL_NFSROOT}') \

%:
	${MAKE} ${KERNEL_ARGS} $@

.generic-build:
	${MAKE} ${KERNEL_ARGS}

.modules_install:.%:	modules
	rm -rf "${INSTALL_MOD_PATH}"/lib/modules
	${MAKE} ${KERNEL_ARGS} $*

check-syntax:
	@${MAKE} -s ${KERNEL_ARGS} -f flymake.mk

## required for building 'menuconfig' with correct libncurses
menuconfig nconfig gconfig:	export PKG_CONFIG_LIBDIR=${BUILDVAR_STAGING_DIR_NATIVE}/usr/lib/pkgconfig

.NOTPARALLEL:
