DESCRIPTION	=  "Framebuffer testutility"
LICENSE		=  "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

PV = "0.4.1+git${SRCPV}"

SRC_URI		=  "git://github.com/sigma-embedded/fbtest.git;protocol=https"
SRCREV		=  "c32e1c6e0c91ed0bcc3ee4c6e9ceaa579c353f63"
S		=  "${WORKDIR}/git"

do_compile() {
	oe_runmake -e
}

do_install() {
	install -d ${D}${bindir}
	install -p -m 0755 fbtest ${D}${bindir}/elito-fbtest
}
