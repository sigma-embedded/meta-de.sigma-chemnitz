SUMMARY = "rescue system updater"
LICENSE = "GPLv3"
DEPENDS = "libccgi"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

PV   = "0.2.12+git${SRCPV}"

SRCREV  = "cce565a26d7c568332d26a0ae7cf584b542309f3"
SRC_URI = "${ELITO_PUBLIC_GIT_REPO}/elito-rescue-utils.git"

inherit autotools-brokensep

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

RDEPENDS:${PN} += "elito-image-stream-decode virtual/rescue-conf"

PACKAGES += "${PN}-http"

FILES:${PN}-dbg += "/srv/www/cgi-bin/.debug"

FILES:${PN} = "${datadir}/elito-rescue ${bindir}/*"

RDEPENDS:${PN}-http += "${PN}"
FILES:${PN}-http += "\
  ${wwwdir}/index.html \
  ${wwwdir}/cgi-bin/image-update.cgi \
"
