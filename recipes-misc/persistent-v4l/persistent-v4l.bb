LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = "file://persistent-v4l.rules"

do_install() {
	install -D -p -m 0644 ${WORKDIR}/persistent-v4l.rules \
		${D}/lib/udev/rules.d/61-persistent-v4l.rules
}

FILES_${PN} = "/lib/udev/rules.d/*.rules"
