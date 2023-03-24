LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Register defintions for use with elito-decode-registers"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions;branch=master"
SRCREV  = "875dc9c4c1248033e4847e2882dd0453c83c4e70"

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
_DECODERS_CPU_mx8mq = "mx8mq"
_DECODERS_CPU_mx8mm = "mx8mm"
_DECODERS_CPU_mx6q  = "mx6q"
_DECODERS_CPU_mx6qp = "mx6qp"
_DECODERS_CPU_mx6dl = "mx6dl"
_DECODERS_CPU_mx6s  = "mx6dl"

DECODERS = "${_DECODERS_CPU}"

ALL_DECODERS ?= "${@oe.utils.ifelse(d.getVar('DECODERS', True).strip(), '', '1')}"

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

RDEPENDS_${PN} += "bash elito-decode-registers"
