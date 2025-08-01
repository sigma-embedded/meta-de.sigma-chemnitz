# --*- bitbake -*--

PACKAGE_ARCH = "${MACHINE_ARCH}"
PROVIDES = "virtual/bootloader"

BAREBOX_REVISION ??= "${SRCREV_barebox_${BASE_PV}}"

BAREBOX_DEFCONFIG ??= "${UNPACKDIR}/defconfig"
KCONFIG_DEFCONFIG = "${BAREBOX_DEFCONFIG}"

BAREBOX_DEPLOY_NAME ??= "barebox"
BAREBOX_IMG_TYPES ??= ".img"
BAREBOX_IMG_TYPES[type] = "list"

inherit elito-kconfig

unset CFLAGS
unset LDFLAGS

# to be overridden in .bbappend
COMPATIBLE_MACHINE  = "(-)"
IMGBASE ??= "${MACHINE}"

inherit pkgconfig

## usage: _run_install <dst-dir>
_run_install() {
	for img in .elf ${@oe.data.typed_value("BAREBOX_IMG_TYPES", d)}; do
	    first=
	    for b in ${IMGBASE}; do
		src_b=${b%%:*}
		tgt_b=${b##${src_b}:}

		test -n "$first" || first=${BAREBOX_DEPLOY_NAME}-$tgt_b-${PV}-${PR}

		case $img in
		.elf)
			s=${B}/barebox
			;;
		*)
			s=${B}/images/barebox-$src_b$img
			;;
		esac

                t=${BAREBOX_DEPLOY_NAME}-$tgt_b-${PV}-${PR}$img
		l=${BAREBOX_DEPLOY_NAME}-$tgt_b$img

		install -p -m 0644 "$s" "$1/$t"
		ln -sf "$t" "$1/$l"
	    done

	    ln -sf "$first"$img                          "$1"/${BAREBOX_DEPLOY_NAME}$img
	done
}

inherit deploy

do_deploy() {
	_run_install "${DEPLOYDIR}"
}
addtask do_deploy before do_build after do_compile
