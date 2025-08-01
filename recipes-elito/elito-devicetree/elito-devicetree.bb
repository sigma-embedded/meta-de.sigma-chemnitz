DESCRIPTION  = "${MACHINE} device tree"
LICENSE      = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

PACKAGE_ARCH = "${MACHINE_ARCH}"

INHIBIT_DEFAULT_DEPS = "1"
EXTRA_OEMAKE = "\
  -f ${STAGING_DIR_NATIVE}/${datadir}/elito-devicetree-tools/devicetree.mk \
  abs_top_srcdir='${S}' \
  MACHINE=${MACHINE} \
  prefix=${prefix} datadir=${datadir} \
  pkgdatadir=${MACHDATADIR} \
  KERNEL_DIR=${STAGING_KERNEL_DIR} \
  MACHINE_INCDIR=${MACHINCDIR} \
  KERNEL_DTREE_DIR=${KERNEL_DTREE_DIR} \
"

EXTRA_OEMAKE:append:mx28-generic-bsp = " SOC_FAMILY=mx28"

MACH_DEPENDS = ""
MACH_DEPENDS:mx28-generic-bsp = "mx28-pins"

DEPENDS += "dtc-native ${MACH_DEPENDS} virtual/cross-cc"
DEPENDS += "elito-devicetree-tools-cross-${TARGET_ARCH}"

B := "${S}"
S  = "${UNPACKDIR}"

require elito-devicetree-common.inc
inherit deploy elito-machdata elito-dtree-base

do_emit_buildvars[depends] += "virtual/kernel:do_symlink_kernsrc"
