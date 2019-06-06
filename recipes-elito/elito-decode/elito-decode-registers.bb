LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Tool to interpret register contents"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-registers"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-registers.git"
SRCREV  = "28d730af20bb824ea1aa20d95f26afc7cf0dce7f"

S = "${WORKDIR}/git"

## do not use ${PYTHON} here; the shebang line becomes too large else
EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
    PYTHON3='/usr/bin/env python3' \
"

BBCLASSEXTEND += "cross crosssdk"

inherit python3native

python () {
    override = d.getVar("CLASSOVERRIDE", True) or ""
    if override == "class-cross":
        d.appendVar("PN", "-${TARGET_ARCH}")
        d.setVar("SPECIAL_PKGSUFFIX", "-cross-${TARGET_ARCH}")
}

do_compile() {
	oe_runmake all
}

do_install() {
	oe_runmake install DESTDIR=${D}
}
