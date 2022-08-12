## legacy method; remove me!
do_nfs_export() {
	echo "${IMAGE_ROOTFS} (ro,no_root_squash,no_all_squash,insecure)" > "${WORKDIR}/exports"
}
addtask do_nfs_export before do_build

do_emit_buildvars[depends] += "\
    unfs3-native:do_build \
    rsync-native:do_build \
"

NFS_ROOTFS_BASEDIR ?= "${DEPLOY_DIR}/rootfs/roots"
NFS_ROOTFS_METADIR ?= "${DEPLOY_DIR}/rootfs/meta"
NFS_ROOTFS_IMGDIR  ?= "${NFS_ROOTFS_BASEDIR}/${MACHINE}/${PN}"

inherit elito-emit-buildvars

BUILDVARS_EMIT = "true"
BUILDVARS_EXPORT += "\
    IMAGE_ROOTFS \
    FAKEROOTENV \
    FAKEROOTCMD \
    PSEUDO_SYSROOT \
    DEPLOY_DIR \
    COMPONENTS_DIR \
    IMAGE_LINK_NAME \
    DEPLOY_DIR_IMAGE \
    NFS_ROOTFS_METADIR \
    NFS_ROOTFS_BASEDIR \
    NFS_ROOTFS_IMGDIR \
"
