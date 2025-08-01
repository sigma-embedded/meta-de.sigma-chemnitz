## --*- bitbake -*--
SECTION = "kernel"

CFGSET ??= ""
PATCHSET ??= ""

PROVIDES = "virtual/kernel"

SRC_URI = "${KERNEL_URI} ${PATCHSET} ${CFGSET}"

KERNEL_REVISION ??= "${SRCREV_kernel_${BASE_PV}}"
SRCREV = "${KERNEL_REVISION}"

# to be overridden in .bbappend
COMPATIBLE_MACHINE  = "(-)"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""

# required for working 'menuconfig'
DEPENDS += "pkgconfig-native"

inherit kernel
inherit elito-kconfig

kernel_do_compile[vardepsexclude] += "REPRODUCIBLE_TIMESTAMP_ROOTFS"

kernel_deploy_dot_config() {
	for imageType in ${KERNEL_IMAGETYPES} ; do
		base_name=${imageType}-${KERNEL_IMAGE_NAME}
		install -m 0644 ${B}/.config $deployDir/${base_name}.config
		symlink_name=${imageType}-${KERNEL_IMAGE_LINK_NAME}
		ln -sf ${base_name}.config $deployDir/${symlink_name}.config
		ln -sf ${base_name}.config $deployDir/${imageType}.config
	done
}

do_deploy:append() {
	kernel_deploy_dot_config
}

## HACK: kernel.bbclass is broken for non-poky kernels; sources are
## expected to be in STAGING_KERNEL_DIR and with preventing the manual
## setup of 'S' in recent OE versions, this can not be triggered anymore
##
## Simulate ${S} != ${STAGING_KERNEL_DIR} behavior and the following
## symlink operations by setting S temporarily to the actual location.
##
## NOTE: kernel-yocto has a do_kernel_checkout() task which does the
## moving / symlink
do_symlink_kernsrc:prepend () {
    d = d.createCopy()
    s = d.expand("${UNPACKDIR}/${BB_GIT_DEFAULT_DESTSUFFIX}")
    d.setVar('S', s)
}
