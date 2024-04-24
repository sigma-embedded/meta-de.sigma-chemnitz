EXT_FIRMWARE_DIR = "${WORKDIR}/ext-firmware"

EXTRA_OEMAKE += "\
    CONFIG_EXTRA_FIRMWARE_DIR='${EXT_FIRMWARE_DIR}' \
"

DEPENDS += "\
    imx-atf \
    imx-boot-firmware-files \
"

BL31_NAME:mx8mn-generic-bsp	= "imx8mn-bl31.bin"
BL31_NAME:mx8mm-generic-bsp	= "imx8mm-bl31.bin"
BL31_NAME:mx8mp-generic-bsp	= "imx8mp-bl31.bin"

do_prepare_fw[dirs] = "${EXT_FIRMWARE_DIR}"
do_prepare_fw[cleandirs] = "${EXT_FIRMWARE_DIR}"
do_prepare_fw[depends] += "\
    imx-boot-firmware-files:do_deploy \
    imx-atf:do_deploy \
"
do_prepare_fw() {
    rm -f '${BL31_NAME}'
    ln -s ${DEPLOY_DIR_IMAGE}/bl31.bin '${BL31_NAME}'

    for fw in ${DDR_FIRMWARE_NAME}; do
	# strip the _200206 like version suffix; barebox
	# expects the plain names
	base=${fw%%_[0-9][0-9][0-9][0-9][0-9][0-9].bin}
	base=${base%%.bin}.bin

        rm -f "$base"
        ln -s ${DEPLOY_DIR_IMAGE}/"$fw" ./"$base"
    done
}
addtask do_prepare_fw before do_configure
