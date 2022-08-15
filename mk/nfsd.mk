ifeq (${BUILDVARS_DATA},)
$(error "missing BUILDVARS_DATA")
endif

_nfsd_mk_dir := $(dir $(lastword ${MAKEFILE_LIST}))

include ${_nfsd_mk_dir}/nfs-opt.mk
include ${BUILDVARS_DATA}

BUILDVAR_WS_DIR ?=

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
	${BUILDVAR_WS_DIR} \

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

RSYNCD =		$(dir ${BUILDVAR_PSEUDO_SYSROOT})/rsync-native/usr/bin/rsync
RSYNCD_CONFIG =		${ROOTFS_METADIR}/rsyncd.conf
RSYNCD_PIDFILE =	${ROOTFS_METADIR}/rsyncd.pid
RSYNCD_FLAGS = \
	--daemon \
	--config ${RSYNCD_CONFIG}

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

info-daemon:
	@echo "tarball: " ${IMAGE_TARBALL}

start-daemon:
stop-daemon:
status-daemon:



## unfs3
start-daemon:	.start-unfsd
.start-unfsd:	${UNFSD_EXPORTS}
	$(call pseudo,${UNFSD} ${UNFSD_FLAGS})

stop-daemon:	.stop-unfsd
.stop-unfsd:
	-test ! -e "${UNFSD_PIDFILE}" || kill "`cat ${UNFSD_PIDFILE}`"
	-$Q${PSEUDO_CMD} -S

status-daemon:	.status-unfsd
.status-unfsd:
	$Q if test -s "${UNFSD_PIDFILE}" && kill -0 "`cat ${UNFSD_PIDFILE}`"; then \
		echo "unfs3 daemon is running with pid `cat ${UNFSD_PIDFILE}`"; \
	else \
		echo "unfs3 daemon is not running"; \
	fi

## rsyncd
start-daemon:	.start-rsyncd
.start-rsyncd:	${RSYNCD_CONFIG}
	$(call pseudo,${RSYNCD} ${RSYNCD_FLAGS})

stop-daemon:	.stop-rsyncd
.stop-rsyncd:
	-test ! -e "${RSYNCD_PIDFILE}" || kill "`cat ${RSYNCD_PIDFILE}`"
	-$Q${PSEUDO_CMD} -S

status-daemon:	.status-rsyncd
.status-rsyncd:
	$Q if test -s "${RSYNCD_PIDFILE}" && kill -0 "`cat ${RSYNCD_PIDFILE}`"; then \
		echo "rsyncd daemon is running with pid `cat ${RSYNCD_PIDFILE}`"; \
	else \
		echo "rsyncd daemon is not running"; \
	fi

## helper targets
${UNFSD_EXPORTS}:
	@rm -f '$@'
	@echo '${ROOTFS_BASEDIR} (ro,no_root_squash,no_all_squash,insecure)' > $@

${RSYNCD_CONFIG}:	${MAKEFILE_LIST}
	@rm -f '$@'
	@echo 'pid file = ${RSYNCD_PIDFILE}' >$@
	@echo 'port     = ${RSYNCD_PORT}'   >>$@
	@echo '[rootfs]'                    >>$@
	@echo 'path = ${ROOTFS_BASEDIR}'    >>$@
	@echo 'read only = true'            >>$@
	@echo 'open noatime = true'	    >>$@
	@echo '[images]'                    >>$@
	@echo 'path = $(dir ${BUILDVAR_DEPLOY_DIR_IMAGE})' >>$@
	@echo 'read only = true'            >>$@
	@echo 'open noatime = true'	    >>$@
ifneq ($(wildcard ${BUILDVAR_WS_DIR}/www),)
	@echo '[www]'                    >>$@
	@echo 'path = $(abspath ${BUILDVAR_WS_DIR}/www)' >>$@
	@echo 'read only = true'            >>$@
	@echo 'open noatime = true'	    >>$@
endif
