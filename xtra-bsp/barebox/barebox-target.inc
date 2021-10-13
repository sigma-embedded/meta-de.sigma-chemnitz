# --*- bitbake -*--

PACKAGE_ARCH = "${MACHINE_ARCH}"

BAREBOX_REVISION ??= "${SRCREV_barebox_${BASE_PV}}"
PROVIDES = "virtual/bootloader"

BAREBOX_DEFCONFIG ??= "${WORKDIR}/defconfig"
KCONFIG_DEFCONFIG = "${BAREBOX_DEFCONFIG}"

BAREBOX_DEPLOY_NAME ??= "barebox"

inherit kernel-arch elito-kconfig

unset CFLAGS
unset LDFLAGS

# to be overridden in .bbappend
COMPATIBLE_MACHINE  = "(-)"
IMGBASE ??= "${MACHINE}"

EXTRA_OEMAKE += "\
    -C ${S} \
    KBUILD_OUTPUT=${B} V=1 \
    CROSS_COMPILE='${TARGET_PREFIX}' \
    CC='${KERNEL_CC}' \
    LD='${KERNEL_LD}' \
    HOSTCC='${BUILD_CC}' \
    HOSTCPP='${BUILD_CPP}' \
"

## usage: _run_install <dst-dir>
_run_install() {
	install -D -p -m 0644 ${B}/barebox               "$1"/${BAREBOX_DEPLOY_NAME}-${IMGBASE}-${PV}-${PR}.elf
	ln -sf ${BAREBOX_DEPLOY_NAME}-${IMGBASE}-${PV}-${PR}.elf "$1"/${BAREBOX_DEPLOY_NAME}-${IMGBASE}.elf

	first=
	for b in ${IMGBASE}; do
		test -n "$first" || first=${BAREBOX_DEPLOY_NAME}-$b-${PV}-${PR}
		install -p -m 0644 ${B}/images/barebox-$b.img    "$1"/${BAREBOX_DEPLOY_NAME}-$b-${PV}-${PR}.img
		ln -sf ${BAREBOX_DEPLOY_NAME}-$b-${PV}-${PR}.img "$1"/${BAREBOX_DEPLOY_NAME}-$b.img
	done

	ln -sf ${BAREBOX_DEPLOY_NAME}-${IMGBASE}.elf "$1"/${BAREBOX_DEPLOY_NAME}.elf
	ln -sf "$first".img                          "$1"/${BAREBOX_DEPLOY_NAME}.img
}

inherit deploy

do_deploy() {
	_run_install "${DEPLOYDIR}"
}
addtask do_deploy before do_build after do_compile
