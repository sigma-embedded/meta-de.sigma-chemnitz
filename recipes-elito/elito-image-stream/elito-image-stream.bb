SUMMARY = "ELiTo image stream tools"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

_pv     = "0.2.10"

SRCREV  = "9ae194778952db44c13c10c0b3948160a205f8f3"
SRC_URI = "${ELITO_PUBLIC_GIT_REPO}/elito-image-stream.git"

PV   = "${_pv}+gitr${SRCPV}"
PKGV = "${_pv}+gitr${GITPKGV}"

inherit gitpkgv autotools-brokensep

PACKAGECONFIG ??= "digest-gnutls x509-gnutls compression-noop"
PACKAGECONFIG_virtclass-native = "digest-gnutls x509-gnutls compression-noop"

PACKAGECONFIG[digest-gnutls] = "DIGEST_PROVIDER=gnutls,,gnutls,"
PACKAGECONFIG[digest-kernel] = "DIGEST_PROVIDER=kernel,,,"
PACKAGECONFIG[x509-gnutls]   = "X509_PROVIDER=gnutls,,gnutls,"
PACKAGECONFIG[x509-noop]     = "X509_PROVIDER=noop,,,"
PACKAGECONFIG[compression-noop] = "COMPRESSION_PROVIDER=noop,,,"

DEPENDS += "gnutls zlib"

EXTRA_OEMAKE += "\
  prefix=${prefix} \
  bindir=${bindir} \
  progprefix=elito- \
  ${EXTRA_OECONF} \
"

S = "${WORKDIR}/git"

PACKAGES =+ "${PN}-encode ${PN}-decode ${PN}-utils"
FILES_${PN}-encode = "${bindir}/*-encode"
FILES_${PN}-decode = "${bindir}/*-decode"
FILES_${PN}-utils = "${bindir}/*-dump-progress"

BBCLASSEXTEND = "native"

do_install_append() {
	install -D -p -m 0755 dump-progress ${D}${bindir}/elito-stream-dump-progress
}
