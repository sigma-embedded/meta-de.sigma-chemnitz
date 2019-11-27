## --*- bitbake -*--
require u-boot-target.inc

BOOT_TOOLS = "imx-boot-tools"
UBOOT_SUFFIX = ".bin"

_run_install_append() {
	install -p -m 0644 ${B}/spl/u-boot-spl.bin "$1"/SPL-${PV}-${PR}.bin
	ln -sf SPL-${PV}-${PR}.bin  "$1"/SPL.bin

	install -p -m 0644 ${B}/dts/dt.dtb "$1"/u-boot-${PV}-${PR}.dtb
	ln -sf u-boot-${PV}-${PR}.dtb "$1"/u-boot.dtb
}

do_deploy_append() {
	install -d -m 0755 "${DEPLOYDIR}"/${BOOT_TOOLS}/
	install -p -m 0644 ${B}/u-boot-nodtb.bin                "${DEPLOYDIR}"/${BOOT_TOOLS}/u-boot-nodtb.bin
	install -p -m 0644 ${B}/arch/arm/dts/${UBOOT_DTB_NAME}  "${DEPLOYDIR}"/${BOOT_TOOLS}/
	install -p -m 0755 ${B}/tools/mkimage                   "${DEPLOYDIR}"/${BOOT_TOOLS}/mkimage_uboot
}
