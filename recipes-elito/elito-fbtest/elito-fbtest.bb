DESCRIPTION	=  "Framebuffer testutility"
LICENSE		=  "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

PV = "0.4.1+git${SRCPV}"

SRC_URI		=  "${ELITO_PUBLIC_GIT_REPO}/fbtest.git;branch=master"
SRCREV		=  "14963f67997f5b01d258acdfa2b6c9d6e3fcba13"
S		=  "${WORKDIR}/git"

do_compile() {
	oe_runmake -e
}

do_install() {
	install -d ${D}${bindir}
	install -p -m 0755 fbtest ${D}${bindir}/elito-fbtest
}
