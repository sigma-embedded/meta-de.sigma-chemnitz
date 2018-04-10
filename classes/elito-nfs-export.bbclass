do_nfs_export() {
	echo "${IMAGE_ROOTFS} (ro,no_root_squash,no_all_squash,insecure)" > "${WORKDIR}/exports"
}
addtask do_nfs_export before do_build

DEPENDS += "unfs3-native"

inherit elito-emit-buildvars

BUILDVARS_EMIT = "true"
BUILDVARS_EXPORT += "\
  IMAGE_ROOTFS \
  FAKEROOTENV \
  FAKEROOTCMD \
"
