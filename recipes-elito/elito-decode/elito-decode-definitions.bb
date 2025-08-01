LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Register defintions for use with elito-decode-registers"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions;branch=master"
SRCREV  = "2cf739938d8978cac0087a1ec8f7ba8ee95c8dea"

PACKAGE_ARCH = "${MACHINE_ARCH}"

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
_DECODERS_CPU:mx8mq-generic-bsp = "mx8mq"
_DECODERS_CPU:mx8mm-generic-bsp = "mx8mm"
_DECODERS_CPU:mx8mp-generic-bsp = "mx8mp"
_DECODERS_CPU:mx8qm-generic-bsp = "mx8qm"
_DECODERS_CPU:mx6q-generic-bsp  = "mx6q"
_DECODERS_CPU:mx6qp-generic-bsp = "mx6qp"
_DECODERS_CPU:mx6dl-generic-bsp = "mx6dl"
_DECODERS_CPU:mx6s-generic-bsp  = "mx6dl"

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

RDEPENDS:${PN} += "bash elito-decode-registers"
