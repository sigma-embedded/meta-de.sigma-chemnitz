# --*- bitbake -*--

PACKAGE_ARCH = "${MACHINE_ARCH}"

BAREBOX_REVISION ??= "${SRCREV_barebox_${BASE_PV}}"
PROVIDES = "virtual/bootloader"

BAREBOX_DEFCONFIG ??= "${WORKDIR}/defconfig"
KCONFIG_DEFCONFIG = "${BAREBOX_DEFCONFIG}"

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
	install -D -p -m 0644 ${B}/barebox        "$1"/barebox-${IMGBASE}-${PV}-${PR}.elf
	ln -sf barebox-${IMGBASE}-${PV}-${PR}.elf "$1"/barebox-${IMGBASE}.elf

	first=
	for b in ${IMGBASE}; do
		test -n "$first" || first=barebox-$b-${PV}-${PR}
		install -p -m 0644 ${B}/images/barebox-$b.img "$1"/barebox-$b-${PV}-${PR}.img
		ln -sf barebox-$b-${PV}-${PR}.img "$1"/barebox-$b.img
	done

	ln -sf barebox-${IMGBASE}.elf "$1"/barebox.elf
	ln -sf "$first".img           "$1"/barebox.img
}

inherit deploy

do_deploy() {
	_run_install "${DEPLOYDIR}"
}
addtask do_deploy before do_build after do_compile
