LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = "file://persistent-v4l.rules"

do_install() {
	install -D -p -m 0644 ${UNPACKDIR}/persistent-v4l.rules \
		${D}${nonarch_base_libdir}/udev/rules.d/61-persistent-v4l.rules
}

FILES:${PN} = "${nonarch_base_libdir}/udev/rules.d/*.rules"
