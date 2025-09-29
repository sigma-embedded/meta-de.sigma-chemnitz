# --*- bitbake -*--

CFGSET ??= ""
PATCHSET ??= ""
ENVSET ??= ""
SRC_URI = "\
  ${BAREBOX_BASE_URI}${BAREBOX_REFSPEC} \
  ${ENVSET} \
  ${PATCHSET} \
  ${CFGSET} \
"
SRCREV = "${BAREBOX_REVISION}"

B = "${WORKDIR}/build"

DEPENDS += "lzop-native lz4-native coreutils-native bison-native"

KERNEL_CONFIG_COMMAND ?= "oe_runmake_call -C ${S} CC='${KERNEL_CC}' O=${B} olddefconfig"

do_configure() {
	kernel_do_configure
}
