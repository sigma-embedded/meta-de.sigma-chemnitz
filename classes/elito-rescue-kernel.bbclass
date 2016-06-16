FILESEXTRAPATHS_append = ":${BASEPATH_sigma}/files"

SRC_URI_append = "\
  file://rescue-kernel.cfg \
"

do_compile[depends]    += "virtual/rescue-image:do_rootfs"

PACKAGESPLITFUNCS_remove = "split_kernel_module_packages"

do_compile_prepend() {
	use_alternate_initrd="CONFIG_INITRAMFS_SOURCE=${DEPLOY_DIR_IMAGE}/rescue-image-${MACHINE}.cpio.xz"
}

do_install_append() {
	# cleanup to to avoid 'installed-vs-shipped'
	rmdir \
		${D}${sysconfdir}/modules-load.d \
		${D}${sysconfdir}/modprobe.d \
		${D}${sysconfdir} || :
}

kernel_do_configure_append() {
	cat <<EOF >> ${B}/.config
CONFIG_CMDLINE="console=${KERNEL_CONSOLE},115200"
EOF
}
