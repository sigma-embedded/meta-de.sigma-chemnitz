## --*- bitbake -*--
inherit elito-kconfig
inherit deploy

DEPENDS += "dtc-native bc-native bison-native"
PROVIDES = "virtual/bootloader u-boot"
PACKAGE_ARCH = "${MACHINE_ARCH}"

# to be overridden in .bbappend
COMPATIBLE_MACHINE ??= "none"

UBOOT_PROVIDE_FW_ENV_CONFIG ??= "false"
UBOOT_PROVIDE_FW_ENV_CONFIG[type] = "boolean"

SRC_URI += "\
    ${@'file://fw_env.config' if oe.data.typed_value('UBOOT_PROVIDE_FW_ENV_CONFIG', d) else ''} \
"

CFGSET = "\
"

do_configure() {
	kernel_do_configure
}

do_compile () {
	oe_runmake
}

## usage: _run_install <dst-dir>
_run_install() {
	install -d -m 0755 "$1"
	install -p -m 0644 ${B}/u-boot "$1"/u-boot-${PV}-${PR}.elf
	ln -sf u-boot-${PV}-${PR}.elf  "$1"/u-boot.elf

	for s in ${UBOOT_SUFFIX}; do
		install -D -p -m 0644 ${B}/u-boot$s "$1"/u-boot-${PV}-${PR}$s
		ln -sf u-boot-${PV}-${PR}$s         "$1"/u-boot$s
	done
}

do_install() {
	if ${@['false', 'true'][oe.data.typed_value('UBOOT_PROVIDE_FW_ENV_CONFIG', d)]}; then
		install -D -p -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
	fi

	_run_install "${D}/boot"
}

do_deploy[cleandirs] = "${DEPLOYDIR}"
do_deploy() {
	_run_install "${DEPLOYDIR}"
	install -p -m 0644 ${B}/.config  "${DEPLOYDIR}"/u-boot-${PV}-${PR}.config
	ln -sf u-boot-${PV}-${PR}.config "${DEPLOYDIR}"/u-boot.config
}
addtask deploy before do_build after do_install

PACKAGE_BEFORE_PN += "\
    ${@'${PN}-env' if oe.data.typed_value('UBOOT_PROVIDE_FW_ENV_CONFIG', d) else ''} \
"

RPROVIDES:${PN}-env += "u-boot-default-env"
FILES:${PN}-env = "${sysconfdir}/fw_env.config"

FILES:${PN} = "/boot"

INSANE_SKIP:${PN} = "textrel"
