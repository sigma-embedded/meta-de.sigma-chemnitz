LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"
HOMEPAGE = "http://jwilk.net/software/fbcat"

PV = "0.5.2"

SRC_URI = "\
    git+https://github.com/jwilk/fbcat.git \
"

SRCREV = "fe1b2995fa45e863f7ce7b24b91df0a2c511e6e3"

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
	rm -f fbgrap
	ln ${S}/fbgrab ${B}/
}

do_compile() {
	oe_runmake -B
}

do_install() {
	oe_runmake install DESTDIR=${D}
}
