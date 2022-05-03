EXT_FIRMWARE_DIR = "${WORKDIR}/ext-firmware"

EXTRA_OEMAKE += "\
    CONFIG_EXTRA_FIRMWARE_DIR='${EXT_FIRMWARE_DIR}' \
"

DEPENDS += "\
    imx-atf \
    firmware-imx-8m \
"

BL31_NAME:mx8mn-generic-bsp	= "imx8mn-bl31.bin"
BL31_NAME:mx8mm-generic-bsp	= "imx8mm-bl31.bin"

do_firmware_prepare[dirs] = "${EXT_FIRMWARE_DIR}"
do_firmware_prepare[cleandirs] = "${EXT_FIRMWARE_DIR}"
do_firmware_prepare() {
	src='${STAGING_DATADIR}'
	lnr "$src"/imx-atf/bl31.bin '${BL31_NAME}'
	for f in "$src"/firmware-imx-8m/*.bin; do
		test -e "$f" || continue
		base=`basename "$f"`
		lnr "$f" "$base"
	done
}
addtask do_firmware_prepare before do_compile after do_prepare_recipe_sysroot
