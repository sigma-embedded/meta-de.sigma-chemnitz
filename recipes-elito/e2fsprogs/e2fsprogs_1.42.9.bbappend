FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "\
  file://chmod-modes.patch \
  file://e2fsck.conf \
"

do_install_append() {
  f=${WORKDIR}/e2fsck.conf
  ! test -s "$f" || \
  install -D -p -m 0644 "$f" ${D}${sysconfdir}/e2fsck.conf
}

FILES_e2fsprogs-e2fsck += "${sysconfdir}/e2fsck.conf"
