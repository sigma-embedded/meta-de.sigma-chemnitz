FILESEXTRAPATHS_append = ":${BASEPATH_sigma}/files"

SRC_URI_append = "\
  file://rescue-kernel.cfg \
"

do_compile[depends]    += "virtual/rescue-image:do_rootfs"

PACKAGESPLITFUNCS_remove = "split_kernel_module_packages"

do_install_append() {
	# cleanup to to avoid 'installed-vs-shipped'
	rmdir \
		${D}${sysconfdir}/modules-load.d \
		${D}${sysconfdir}/modprobe.d \
		${D}${sysconfdir} || :
}

cml1_do_configure_prepend() {
	kconfig_set CMDLINE "\"console=${KERNEL_CONSOLE},115200n8 quiet\""
	kconfig_set INITRAMFS_SOURCE \"${DEPLOY_DIR_IMAGE}/rescue-image-${MACHINE}.cpio.xz\"
}
