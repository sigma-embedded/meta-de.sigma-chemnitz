ifeq (${BUILDVARS_DATA},)
$(error "missing BUILDVARS_DATA")
endif

_nfsd_mk_dir := $(dir $(lastword ${MAKEFILE_LIST}))

include ${_nfsd_mk_dir}/nfs-opt.mk
include ${BUILDVARS_DATA}

_space = $(eval) $(eval)
_comma = ,

ROOTFS_BASEDIR =	${BUILDVAR_NFS_ROOTFS_BASEDIR}
ROOTFS_METADIR =	${BUILDVAR_NFS_ROOTFS_METADIR}
ROOTFS_DIR =		${BUILDVAR_NFS_ROOTFS_IMGDIR}
ROOTFS_ALL_DIRS =	$(sort $(abspath $(wildcard ${ROOTFS_BASEDIR}/*/*) ${ROOTFS_DIR}))

PSEUDO_IGNORE_PATHS = \
	/bin /dev /etc /home /lib /lib64 /mnt \
	/proc /run /sbin /sys /tmp /usr /var \
	${BUILDVAR_DEPLOY_DIR}/images \
	${BUILDVAR_TMPDIR}/pcache \
	${ROOTFS_METADIR} \
	${BUILDVAR_COMPONENTS_DIR} \

PSEUDO = ${BUILDVAR_PSEUDO_SYSROOT}/usr/bin/pseudo

PSEUDO_CMD = \
	env \
	PSEUDO_PREFIX=${BUILDVAR_PSEUDO_SYSROOT}/usr \
	PSEUDO_LOCALSTATEDIR=${ROOTFS_METADIR}/.pseudo \
	PSEUDO_PASSWD='$(subst ${_space},:,$(strip ${ROOTFS_ALL_DIRS})):/' \
	PSEUDO_NOSYMLINKEXP=1 \
	PSEUDO_IGNORE_PATHS='$(subst ${_space},${_comma},$(strip ${PSEUDO_IGNORE_PATHS}))' \
	${PSEUDO}

UNFSD =			$(dir ${BUILDVAR_PSEUDO_SYSROOT})/unfs3-native/usr/bin/unfsd
UNFSD_PIDFILE =		${ROOTFS_METADIR}/unfsd.pid
UNFSD_EXPORTS =		${ROOTFS_METADIR}/exports

UNFSD_FLAGS = \
	-t \
	-i ${UNFSD_PIDFILE} \
	-p \
	-e '${UNFSD_EXPORTS}' \
	-n "${UNFSD_NFS_PORT}" \
	-m "${UNFSD_MOUNT_PORT}"

IMAGE_BASE =		${BUILDVAR_DEPLOY_DIR_IMAGE}/${BUILDVAR_IMAGE_LINK_NAME}
IMAGE_TARBALL ?=	$(firstword $(abspath ${IMAGE_BASE}.tar ${IMAGE_BASE}.tar.xz ${IMAGE_BASE}))

TAR_XF = $(strip \
	$(if $(filter %.xz,$1),xJf,\
	$(if $(filter %.bz,$1),xjf,\
	$(if $(filter %.gz,$1),xzf,\
	xf)))) '$1'

define pseudo
	@printf '\t[PSEUDO] %s\n' '$1'
	@${PSEUDO_CMD} $1

endef

all:	status-daemon

image-install sync-daemon:	${IMAGE_TARBALL}
	$(call pseudo,rm -rf '${ROOTFS_DIR}')
	$(call pseudo,install -d -m 0755 -o root -g root '${ROOTFS_DIR}')
	$(call pseudo,tar $(call TAR_XF,$<) -C '${ROOTFS_DIR}')
	@rm -f '${ROOTFS_BASEDIR}/latest' '${ROOTFS_BASEDIR}/${BUILDVAR_MACHINE}/latest'
	-@ln -sr '${ROOTFS_DIR}' '${ROOTFS_BASEDIR}/latest'
	-@ln -sr '${ROOTFS_DIR}' '${ROOTFS_BASEDIR}/${BUILDVAR_MACHINE}/latest'

repair-daemon:	stop-daemon
	${PSEUDO_CMD} -B

start-daemon:	${UNFSD_EXPORTS}
	$(call pseudo,${UNFSD} ${UNFSD_FLAGS})

stop-daemon:
	-test ! -e "${UNFSD_PIDFILE}" || kill "`cat ${UNFSD_PIDFILE}`"
	-@${PSEUDO_CMD} -S

status-daemon:
	@if test -s "${UNFSD_PIDFILE}" && kill -0 "`cat ${UNFSD_PIDFILE}`"; then \
		echo "daemon is running with pid `cat ${UNFSD_PIDFILE}`"; \
	else \
		echo "daemon is not running"; \
	fi

${UNFSD_EXPORTS}:
	rm -f '$@'
	echo '${ROOTFS_BASEDIR} (ro,no_root_squash,no_all_squash,insecure)' > $@

info-daemon:
	ls -l ${IMAGE_TARBALL}
