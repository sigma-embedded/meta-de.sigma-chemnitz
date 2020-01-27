### Include it like
###
### | include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/__image_rootfs.mk
###
### into your workspace makefile

ifneq (${IMAGE_RECIPE},)
BUILDVAR_IMAGE_ROOTFS ?= $(shell ${MAKE} -f '${BUILDVAR_BUILDVARS_DEPLOY_DIR}/${IMAGE_RECIPE}.mk' --eval 'emit-rootfs:;@echo $${BUILDVAR_IMAGE_ROOTFS}' emit-rootfs)
else
BUILDVAR_IMAGE_ROOTFS ?= ${BUILDVAR_WORKDIR}/rootfs
endif
