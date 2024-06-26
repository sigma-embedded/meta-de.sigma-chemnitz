LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"
HOMEPAGE = "http://jwilk.net/software/fbcat"

PV = "0.5.3"

SRC_URI = "\
    git+https://github.com/jwilk/fbcat.git;branch=master \
"

SRCREV = "b781b05d2dd12fd2a35705c0fc6cb3667fddee35"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
    VPATH='${S}' \
    PREFIX='${prefix}' \
    bindir='${bindir}' \
    mandir='${mandir}' \
    CFLAGS='${CFLAGS}' \
    CC='${CC}' \
"

do_configure() {
	oe_runmake clean
	rm -f fbgrab
	ln ${S}/fbgrab ${B}/
}

do_compile() {
	oe_runmake -B
}

do_install() {
	oe_runmake install DESTDIR=${D}
}
