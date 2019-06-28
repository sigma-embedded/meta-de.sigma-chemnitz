LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Register defintions for use with elito-decode-registers"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions"
SRCREV  = "286440827834d93df927195476cac6b4d6133061"

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

_OEMAKE_DECODERS = "\
    DEVICES='${DECODERS}' \
"

EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
    DECODE_PKGDATA_DIR='${STAGING_DATADIR_NATIVE}/decode-registers' \
    ${@oe.utils.ifelse(d.getVar('ALL_DECODERS', True), '', d.getVar('_OEMAKE_DECODERS', False))} \
"

DEPENDS += "elito-decode-registers-cross-${TARGET_ARCH}"

_DECODERS_CPU = ""
_DECODERS_CPU_mx8mq = "mx8m"
_DECODERS_CPU_mx6q  = "mx6q"
_DECODERS_CPU_mx6dl = "mx6dl"

DECODERS = "${_DECODERS_CPU}"

ALL_DECODERS ?= "${@oe.utils.ifelse(d.getVar('DECODERS', True).strip(), '', '1')}"
DECODERS_RDEPS ?= " \
    ${@oe.utils.ifelse(d.getVar('ALL_DECODERS', True), 'bash', '')} \
"

do_configure() {
	oe_runmake clean
}

do_compile() {
	oe_runmake all
}

do_install() {
	oe_runmake install DESTDIR=${D}
	install -d -m 0755 ${D}${datadir}/${PN}
}

RDEPENDS_${PN} += "${DECODERS_RDEPS} elito-decode-registers"
