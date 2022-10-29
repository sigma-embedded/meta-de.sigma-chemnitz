## --*- bitbake -*--
UBOOT_REVISION ??= "${SRCREV_uboot_${BASE_PV}}"

CFGSET ??= ""
PATCHSET ??= ""
SRC_URI = "\
    ${UBOOT_BASE_URI}${UBOOT_REFSPEC} \
    ${PATCHSET} \
    ${CFGSET} \
"
SRCREV = "${UBOOT_REVISION}"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

CROSS_COMPILE = ""
CROSS_COMPILE:class-target = "${TARGET_PREFIX}"
CROSS_COMPILE:class-nativesdk = "${HOST_PREFIX}"

UBOOT_CC = "${KERNEL_CC}${TOOLCHAIN_OPTIONS}"

## todo: strip the '--hash-style' from ${LDFLAGS}?
UBOOT_LD = "${KERNEL_LD} --hash-style=gnu"

EXTRA_OEMAKE = " \
    -C '${S}' O='${B}' \
    CROSS_COMPILE='${CROSS_COMPILE}' \
    CC='${UBOOT_CC}' \
    LD='${UBOOT_LD}' \
    HOSTCC='${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}' \
    V=1 \
    STRIP=true \
"

DEPENDS += "bc-native lzop-native"

PV = "${BASE_PV}+git${SRCPV}"

KERNEL_CONFIG_COMMAND ?= "oe_runmake_call -C ${S} O=${B} olddefconfig"

inherit kernel-arch
