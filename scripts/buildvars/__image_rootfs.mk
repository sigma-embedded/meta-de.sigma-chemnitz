### Include it like
###
### | include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/__image_rootfs.mk
###
### into your workspace makefile

ifneq (${IMAGE_RECIPE},)
BUILDVAR_IMAGE_ROOTFS ?= $(shell ${MAKE} -f '${BUILDVAR_BUILDVARS_DEPLOY_DIR}/${IMAGE_RECIPE}.mk' --eval 'emit-rootfs:;@echo $${BUILDVAR_NFS_ROOTFS_IMGDIR}' emit-rootfs)
BUILDVAR_IMAGE_FAKEROOTCMD ?= $(shell ${MAKE} -f '${BUILDVAR_BUILDVARS_DEPLOY_DIR}/${IMAGE_RECIPE}.mk' --eval 'emit-fakerootcmd:;@echo $${BUILDVAR_FAKEROOTCMD}' emit-fakerootcmd)
BUILDVAR_IMAGE_FAKEROOTENV ?= $(shell ${MAKE} -f '${BUILDVAR_BUILDVARS_DEPLOY_DIR}/${IMAGE_RECIPE}.mk' --eval 'emit-fakerootenv:;@echo $${BUILDVAR_FAKEROOTENV}' emit-fakerootenv)
else
BUILDVAR_IMAGE_ROOTFS ?= ${BUILDVAR_WORKDIR}/rootfs
endif
