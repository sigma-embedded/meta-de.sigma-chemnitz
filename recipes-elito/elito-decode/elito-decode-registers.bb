LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Tool to interpret register contents"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-registers"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-registers.git"
SRCREV  = "e32f33e40d22817e4c4fc90747f3906149cb5317"

S = "${WORKDIR}/git"
#B = "${WORKDIR}/build"

_PYTHON3 = "/usr/bin/env python3"
_PYTHON3_class-target = "${bindir}/${PYTHON_PN}"

## do not use ${PYTHON} here; the shebang line becomes too large else
EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
    PYTHON3='${_PYTHON3}' \
"

BBCLASSEXTEND += "cross crosssdk"

inherit python3native

python () {
    override = d.getVar("CLASSOVERRIDE", True) or ""
    if override == "class-cross":
        d.appendVar("PN", "-${TARGET_ARCH}")
        d.setVar("SPECIAL_PKGSUFFIX", "-cross-${TARGET_ARCH}")
}

do_configure() {
	oe_runmake clean
}

do_compile() {
	oe_runmake all
}

do_install() {
	oe_runmake install DESTDIR=${D}
}

PACKAGE_BEFORE_PN += "${PN}-tools"

FILES_${PN}-dev += "\
    ${datadir}/decode-registers/c \
    ${datadir}/decode-registers/mk \
"

FILES_${PN}-tools += "\
    ${datadir}/decode-registers/py \
    ${bindir}/decode-registers-gendesc \
"

RDEPENDS_${PN}-tools += "${PYTHON_PN}-core"
