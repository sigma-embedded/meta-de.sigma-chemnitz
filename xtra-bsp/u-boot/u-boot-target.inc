## --*- bitbake -*--
inherit elito-kconfig
inherit deploy

DEPENDS += "dtc-native bc-native bison-native"
PROVIDES = "virtual/bootloader u-boot"
PACKAGE_ARCH = "${MACHINE_ARCH}"

# to be overridden in .bbappend
COMPATIBLE_MACHINE ??= "none"

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
	_run_install "${D}/boot"
}

do_deploy[cleandirs] = "${DEPLOYDIR}"
do_deploy() {
	_run_install "${DEPLOYDIR}"
	install -p -m 0644 ${B}/.config  "${DEPLOYDIR}"/u-boot-${PV}-${PR}.config
	ln -sf u-boot-${PV}-${PR}.config "${DEPLOYDIR}"/u-boot.config
}
addtask deploy before do_build after do_install

FILES_${PN} = "/boot"

INSANE_SKIP_${PN} = "textrel"
