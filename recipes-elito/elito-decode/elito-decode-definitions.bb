LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Register defintions for use with elito-decode-registers"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-definitions"
SRCREV  = "0dd44e75cc49e9ab4994ff149a7cc6a46b7928e6"

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
    DECODE_PKGDATA_DIR='${STAGING_DATADIR_NATIVE}/decode-registers' \
    ${@oe.utils.ifelse(d.getVar('ALL_DECODERS', True), "bin_PROGRAMS='${DECODERS}'", '')} \
"

DEPENDS += "elito-decode-registers-cross-${TARGET_ARCH}"


_DECODERS_CPU = ""
_DECODERS_CPU_mx8mq = "decode-mx8m"
_DECODERS_CPU_mx6q  = "decode-mx6q"
_DECODERS_CPU_mx6dl = "decode-mx6dl"

DECODERS = "${_DECODERS_CPU}"

ALL_DECODERS ?= "${@oe.utils.ifelse(d.getVar('DECODERS', True).strip(), '1', '')}"
DECODERS_RDEPS ?= " \
    ${@oe.utils.ifelse(d.getVar('ALL_DECODERS', True), '', 'bash')} \
"

do_compile() {
	oe_runmake all
}

do_install() {
	oe_runmake install DESTDIR=${D}
}

RDEPENDS_${PN} += "${DECODERS_RDEPS}"
