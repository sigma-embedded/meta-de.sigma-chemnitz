ifeq (${BUILDVARS_DATA},)
$(error "missing BUILDVARS_DATA")
endif

_nfsd_mk_dir := $(dir $(lastword ${MAKEFILE_LIST}))

include ${_nfsd_mk_dir}/nfs-opt.mk
include ${BUILDVARS_DATA}

UNFSD ?=	unfsd
UNFSD_PIDFILE = ${BUILDVAR_WORKDIR}/unfsd.pid

UNFSD_CMD = \
	env \
	PATH=${BUILDVAR_PATH}:$${PATH} \
	${BUILDVAR_FAKEROOTENV} \
	${BUILDVAR_FAKEROOTCMD} \
	${UNFSD}

UNFSD_FLAGS = \
	-t \
	-i ${UNFSD_PIDFILE} \
	-p \
	-e ${BUILDVAR_WORKDIR}/exports \
	-n "${UNFSD_NFS_PORT}" \
	-m "${UNFSD_MOUNT_PORT}"

all:	status-daemon

start-daemon:
	${UNFSD_CMD} ${UNFSD_FLAGS}

stop-daemon:
	test ! -e "${UNFSD_PIDFILE}" || kill "`cat ${UNFSD_PIDFILE}`"

status-daemon:
	@if test -s "${UNFSD_PIDFILE}" && kill -0 "`cat ${UNFSD_PIDFILE}`"; then \
		echo "daemon is running with pid `cat ${UNFSD_PIDFILE}`"; \
	else \
		echo "daemon is not running"; \
	fi
