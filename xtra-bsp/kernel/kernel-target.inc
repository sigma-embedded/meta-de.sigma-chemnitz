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

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""

inherit kernel
inherit elito-kconfig

S = "${WORKDIR}/git"

kernel_deploy_dot_config() {
	for imageType in ${KERNEL_IMAGETYPES} ; do
		base_name=${imageType}-${KERNEL_IMAGE_NAME}
		install -m 0644 ${B}/.config $deployDir/${base_name}.config
		symlink_name=${imageType}-${KERNEL_IMAGE_LINK_NAME}
		ln -sf ${base_name}.config $deployDir/${symlink_name}.config
		ln -sf ${base_name}.config $deployDir/${imageType}.config
	done
}

do_deploy_append() {
	kernel_deploy_dot_config
}
