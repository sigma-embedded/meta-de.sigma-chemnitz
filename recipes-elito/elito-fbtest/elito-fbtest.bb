DESCRIPTION	=  "Framebuffer testutility"
LICENSE		=  "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

_pv = "0.4"

PV = "${_pv}+gitr${SRCPV}"
PKGV = "${_pv}+gitr${GITPKGV}"

inherit gitpkgv

SRC_URI		=  "git://github.com/sigma-embedded/fbtest.git;protocol=https"
SRCREV		=  "78d05869c7e0dd9c8166299fe0b9a4bd56ec4e61"
S		=  "${WORKDIR}/git"

do_compile() {
	oe_runmake -e
}

do_install() {
	install -d ${D}${bindir}
	install -p -m 0755 fbtest ${D}${bindir}/elito-fbtest
}
