FILESEXTRAPATHS:append = ":${LAYERDIR_de.sigma-chemnitz.core}/files"

SRC_URI:append = "\
  file://rescue-kernel.cfg \
"

do_compile[depends]    += "virtual/rescue-image:do_rootfs"

PACKAGESPLITFUNCS:remove = "split_kernel_module_packages"

do_install:append() {
	# cleanup to to avoid 'installed-vs-shipped'
	rmdir \
		${D}${sysconfdir}/modules-load.d \
		${D}${sysconfdir}/modprobe.d \
		${D}${sysconfdir} || :
}

cml1_do_configure:prepend() {
	kconfig_set CMDLINE "\"console=${KERNEL_CONSOLE},115200n8 quiet\""
	kconfig_set INITRAMFS_SOURCE \"${DEPLOY_DIR_IMAGE}/rescue-image-${MACHINE}.cpio.xz\"
}
