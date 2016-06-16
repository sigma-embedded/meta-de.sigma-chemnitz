SUMMARY = "rescue system updater"
LICENSE = "GPLv3"
DEPENDS = "libccgi"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

_pv     = "0.2.9"

SRCREV  = "819f06168f4f6cecb46df556aac7aaf4b8ec84bf"
SRC_URI = "${ELITO_PUBLIC_GIT_REPO}/elito-rescue-utils.git"

PV   = "${_pv}+gitr${SRCPV}"
PKGV = "${_pv}+gitr${GITPKGV}"

inherit gitpkgv autotools-brokensep

wwwdir = "/srv/www"

EXTRA_OEMAKE = " \
  LIBS=-lccgi \
  datadir=${datadir} \
  bindir=${bindir} \
  wwwdir=${wwwdir}"

S = "${WORKDIR}/git"

do_unpackextra() {
    sed -i \
        -e 's!@PROJECT@!${PROJECT_NAME}!g' \
        ${S}/cgi/index.html
}
addtask unpackextra after do_unpack before do_configure

RDEPENDS_${PN} += "elito-image-stream-decode virtual/rescue-conf"

PACKAGES += "${PN}-http"

FILES_${PN}-dbg += "/srv/www/cgi-bin/.debug"

FILES_${PN} = "${datadir}/elito-rescue ${bindir}/*"

RDEPENDS_${PN}-http += "${PN}"
FILES_${PN}-http += "\
  ${wwwdir}/index.html \
  ${wwwdir}/cgi-bin/image-update.cgi \
"
