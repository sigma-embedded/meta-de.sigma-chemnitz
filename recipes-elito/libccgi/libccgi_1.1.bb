SUMMARY = "CGI Library for C"
DESCRIPTION = "\
Decodes CGI data from standard input, $QUERY_STRING and $HTTP_COOKIE. \
Stores data in lookup table(s) for easy retrieval. Uploads files by \
copying directly to files created with mkstemp(). Has several handy string \
conversion functions."

LICENSE		= "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

SRC_URI = "\
  http://sourceforge.net/projects/libccgi/files/libccgi/libccgi%20${PV}/ccgi-${PV}.tgz"

SRC_URI[md5sum] = "8fcd31521804e52822da10d0a1532386"
SRC_URI[sha256sum] = "3182c9d1a167a44e001d41801a6b3a173c649cd004a23733f86b15a0362c14fd"

S = "${WORKDIR}/ccgi-${PV}"

EXTRA_OEMAKE = "\
  CRYPT= \
  OPENSSL_INCLUDE= \
  CFLAGS='${CFLAGS} -I.' \
"


do_compile() {
    oe_runmake -e libccgi.a
}

do_install() {
    install -D -p -m 0644 libccgi.a ${D}${libdir}/libccgi.a
    install -D -p -m 0644 ccgi.h    ${D}${includedir}/ccgi.h
}
