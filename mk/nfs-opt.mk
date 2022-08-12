ifneq ($(wildcard /etc/docker-setup.mk),)
include /etc/docker-setup.mk

UNFSD_NFS_PORT ?=	${DOCKER_PORT_INTERNAL_1}
UNFSD_MOUNT_PORT ?=	${DOCKER_PORT_INTERNAL_2}
RSYNCD_PORT ?=		${DOCKER_PORT_INTERNAL_4}

CFG_NFSOPTS_EXTRA = ,port=${DOCKER_PORT_EXPOSED_1},mountport=${DOCKER_PORT_EXPOSED_2}

# ,nfsprog=${DOCKER_PORT_INTERNAL_2},mountprog=${DOCKER_PORT_INTERNAL_3}

else ifneq (${UNFSD_PORT_BASE},)
UNFSD_NFS_PORT ?=	$$[ UNFSD_PORT_BASE + 0 ]
UNFSD_MOUNT_PORT ?=	$$[ UNFSD_PORT_BASE + 1 ]
else
endif

