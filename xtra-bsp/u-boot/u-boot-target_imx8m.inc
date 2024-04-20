## --*- bitbake -*--
require u-boot-target.inc

BOOT_TOOLS = "imx-boot-tools"
UBOOT_SUFFIX = ".bin"

PACKAGECONFIG:append = " swig"
inherit python3native

EXTRA_OEMAKE += "\
    BINMAN_INDIRS='${FWDIR}' \
"

FWDIR = "${WORKDIR}/fw"

do_prepare_fw[dirs] = "${FWDIR}"
do_prepare_fw[cleandirs] = "${FWDIR}"
do_prepare_fw[depends] += "\
    imx-boot-firmware-files:do_deploy \
    imx-atf:do_deploy \
"
do_prepare_fw() {
    for fw in ${DDR_FIRMWARE_NAME} bl31.bin; do
        rm -f "$fw"
        ln -s ${DEPLOY_DIR_IMAGE}/"$fw" ./
    done
}
addtask do_prepare_fw before do_configure

_run_install:append:mx8mp-generic-bsp() {
	install -p -m 0644 ${B}/flash.bin "$1"/flash-${MACHINE}-${PV}-${PR}.bin
	ln -sf flash-${MACHINE}-${PV}-${PR}.bin  "$1"/flash-${MACHINE}.bin
	ln -sf flash-${MACHINE}-${PV}-${PR}.bin  "$1"/flash.bin
}
