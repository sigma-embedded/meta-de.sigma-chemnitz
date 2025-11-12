LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = "\
    file://persistent-v4l.rules \
    file://persistent-media.rules \
"

do_install() {
	d='${D}${nonarch_base_libdir}/udev/rules.d'
	install -D -p -m 0644 ${WORKDIR}/persistent-v4l.rules   $d/61-persistent-v4l.rules
	install -D -p -m 0644 ${WORKDIR}/persistent-media.rules $d/61-persistent-media.rules
}

FILES:${PN} = "${nonarch_base_libdir}/udev/rules.d/*.rules"
