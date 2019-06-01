LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"
SUMMARY = "Tool to interpret register contents"
HOMEPAGE = "https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-registers"

SRC_URI = "git+https://gitlab-ext.sigma-chemnitz.de/elito/misc/elito-decode-registers.git"
SRCREV  = "7b6f446801eb2c4563a3eb478b0827d789db3d9d"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
"

BBCLASSEXTEND += "cross crosssdk"

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
