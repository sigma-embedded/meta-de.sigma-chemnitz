DESCRIPTION  = "${MACHINE} device tree"
LICENSE      = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

PACKAGE_ARCH = "${MACHINE_ARCH}"

MACHINE_DTS_NAME ?= "${MACHINE}"
MACHINE_DTS_NAME[type] = "list"

SRC_URI[vardeps] += "MACHINE_DTS_NAME"
SRC_URI = "\
  ${@' '.join(map(lambda x: 'file://%s.dts' % x, \
                  oe.data.typed_value('MACHINE_DTS_NAME', d)))} \
"

DTBS = " \
    ${@dtb_suffix(d, 'MACHINE_DTS_NAME', 'dtb')} \
    ${@dtb_suffix(d, 'MACHINE_DTSO_NAME', 'dtbo')} \
"

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
  _dtbs='${DTBS}' \
"

EXTRA_OEMAKE_append_mx28 = " SOC_FAMILY=mx28"

COMPATIBLE_MACHINE = "(mx28|mx6|mx7|mx8|ti33x)"

MACH_DEPENDS = ""
MACH_DEPENDS_mx28 = "mx28-pins"

DEPENDS += "dtc-native ${MACH_DEPENDS} virtual/${TARGET_PREFIX}gcc"
DEPENDS += "elito-devicetree-tools-cross-${TARGET_ARCH}"

B := "${S}"
S  = "${WORKDIR}"

require elito-devicetree-common.inc
inherit deploy elito-machdata elito-dtree-base

def dtb_suffix(d, varname, sfx):
    dts = (d.getVar(varname, True) or '').split()
    return ' '.join(map(lambda x: '%s.%s' % (x, sfx), dts))

do_emit_buildvars[depends] += "virtual/kernel:do_symlink_kernsrc"

do_compile[depends] += "virtual/kernel:do_symlink_kernsrc"
do_compile() {
    ## avoid broken deps on not anymore existing files by removing dep
    ## stamp file
    rm -f .*.dts.d
    oe_runmake -e
}

do_install() {
    oe_runmake -e install DESTDIR=${D}
}

do_deploy[cleandirs] = "${DEPLOYDIR}"
do_deploy() {
    for sfx in dtb dtbo; do
        for i in *.$sfx; do
	    test -e "$i" || continue
	    dname=${i%%.$sfx}-"${EXTENDPKGV}".$sfx
	    install -D -p -m 0644 "$i" ${DEPLOYDIR}/"$dname"
	    rm -f ${DEPLOYDIR}/"$i"
	    ln -s "$dname" ${DEPLOYDIR}/"$i"
        done
    done
}
addtask deploy before do_package after do_compile

FILES_${PN}-dev += "${MACHDATADIR}/*.dtb*  ${MACHDATADIR}/*.mk"
RDEPENDS_${PN}-dev += "make"
