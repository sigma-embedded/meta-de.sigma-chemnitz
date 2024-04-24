## --*- bitbake -*--

FW_IN_KERNEL ??= "false"
FW_IN_KERNEL[type] = "boolean"

FW_PACKAGES ??= "\
    linux-firmware \
"

DEPENDS .= "${@' ${FW_PACKAGES}' if oe.data.typed_value('FW_IN_KERNEL', d) else ''}"

do_install_rm_fw_path() {
    ## QA Issue: File /boot/config-... in package kernel-dev contains reference to TMPDIR [buildpaths]
    sed -i 's!^\(CONFIG_EXTRA_FIRMWARE_DIR="\)${STAGING_DIR_TARGET}\(${nonarch_base_libdir}/firmware"\)!\1\2!' ${D}/boot/config-*
}

kernel_generate_dynamic_cfg_set_fwpath() {
    printf 'CONFIG_EXTRA_FIRMWARE_DIR="%s"' '${STAGING_DIR_TARGET}${nonarch_base_libdir}/firmware' > ${CFG_DYNAMIC}
}

do_install:append() {
    if ${@'true' if oe.data.typed_value('FW_IN_KERNEL', d) else 'false'}; then
        do_install_rm_fw_path
    fi
}

kernel_generate_dynamic_cfg:append() {
    if ${@'true' if oe.data.typed_value('FW_IN_KERNEL', d) else 'false'}; then
        kernel_generate_dynamic_cfg_set_fwpath
    fi
}
