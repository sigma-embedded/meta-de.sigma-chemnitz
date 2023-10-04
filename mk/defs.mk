### --*- make -*--

unexport LC_ALL
export LC_CTYPE ?=	en_US.utf-8

top_srcdir :=		$(if ${topdir_srcdir},${top_srcdir},$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
top_builddir :=		$(if ${top_builddir},${top_builddir},$(abspath .))

ORIG_MAKE =		${MAKE} -f '$(abspath $(firstword ${MAKEFILE_LIST}))'

SHELL :=		bash
BITBAKE ?=		bitbake
BITBAKE_DIR ?=		$(top_srcdir)/sources/bitbake
BITBAKE_FLAGS ?=

IMAGE_BASE ?=		$(patsubst %-bundle,%-image,${IMAGE})

BUILDDIR ?=		$(top_builddir)/build
DEPLOY_DIR ?=		${BUILDDIR}/tmp/deploy
OE_TMPDIR ?=		$(shell readlink -f "${BUILDDIR}/tmp")

SHELL_PS1 ?=		[\[\033[1;31m\]${PROJECT}\[\033[0;39m\]|\u@\h \W]\044\040

BB_ENV_EXTRAWHITE ?=
BB_ENV_EXTRAWHITE +=	BB_GENERATE_MIRROR_TARBALLS BBMULTICONFIG

export BB_ENV_PASSTHROUGH_ADDITIONS = ${BB_ENV_EXTRAWHITE}
unexport BB_ENV_EXTRAWHITE

_bitbake =			env ${EXTRA_ENV} ${BITBAKE} ${BITBAKE_FLAGS}

# Usage: $(call init_build_env,<builddir>)
init_build_env = \
	'.' ${OECORE_DIR}/oe-init-build-env $(abspath $1) ${BITBAKE_DIR} > /dev/null

# Usage: $(call bitbake,<builddir>,<recipes>*)
#
# Uses default ${MACHINE}
bitbake = \
	$(call bitbake_machine,$1,$2,${MACHINE})

# Usage: $(call bitbake_machine,<builddir>,<recipes>*,<machine>)
bitbake_machine = \
	$(call init_build_env,$1) && env MACHINE='$3' $(_bitbake) $O $2

## include local customizations
-include ${HOME}/.config/openembedded/toplevel.mk
-include $(HOME)/.config/openembedded/${PROJECT}.mk

all:

image:	FORCE
	$(call bitbake,$(BUILDDIR),$(IMAGE) $(EXTRA_IMAGE))

sdk:	FORCE
	$(call bitbake,$(BUILDDIR),$(IMAGE_BASE) -c populate_sdk)

bitbake: FORCE
	$(call bitbake,$(BUILDDIR),$R$(if $T, -c $T))

clean:	FORCE

mrproper:	clean
	rm -rf .emacs.d
	readlink -f "${BUILDDIR}/tmp"
	test -d "${OE_TMPDIR}"
	rm -rf "${OE_TMPDIR}" "${BUILDDIR}/cache"

shell:	export _PS1=${SHELL_PS1}
shell:	FORCE
	$(call init_build_env,$(BUILDDIR)) && cd $(abspath .) && env ${EXTRA_ENV} MACHINE='${MACHINE}' PS1="$$_PS1" bash

_NFSD_MAKE = \
	${MAKE} \
	-f ${META_SIGMA_DIR}/mk/nfsd.mk \
	--no-print-directory \
	Q='$Q' \
	BUILDVARS_DATA='${DEPLOY_DIR}/buildvars/${MACHINE}/${IMAGE_BASE}.mk'

start-nfsd stop-nfsd status-nfsd repair-nfsd info-nfsd sync-nfsd chown-nfsd:
start-nfsd stop-nfsd status-nfsd repair-nfsd info-nfsd sync-nfsd chown-nfsd:%-nfsd:	FORCE
	+$Q${_NFSD_MAKE} $*-daemon

info:	FORCE
	@printf "Environment:\n"
	@printf "  %20s: %s\n" "PROJECT"   '${PROJECT}'
	@printf "  %20s: %s\n" "MACHINE"   '${MACHINE}'
	@printf "  %20s: %s\n" "IMAGE"     '${IMAGE}'
	@printf "Paths:\n"
	@printf "  %20s: %s\n" "TOPDIR"    '${top_srcdir}'
	@printf "  %20s: %s\n" "BUILDDIR"  '${BUILDDIR}'
	@printf "  %20s: %s\n" "TMPDIR"    '${OE_TMPDIR}'
	@printf "  %20s: %s\n" "DEPLOYDIR" '${DEPLOY_DIR}'

######

.PHONY:		FORCE
FORCE:

###### protect against execution in wrong environment
_NOT_HOST_TARETS ?=
_NOT_HOST_TARETS += \
	all bitbake image sdk shell start-nfsd stop-nfsd status-nfsd sync-nfsd

prohibit-host-environment:	FORCE
${_NOT_HOST_TARETS}:		prohibit-host-environment

###### makeflags

ifneq ($(findstring k,$(firstword -$(MAKEFLAGS))),)
BITBAKE_FLAGS += -k
endif

ifeq (${VV},)
Q = @
else
Q =
endif

BITBAKE_FLAGS += ${BO}

.NOTPARALLEL:

###### Late imports; user might want to do them manually

ifeq (${NO_LATE_IMPORTS},)

###### optional SIGMA setup
-include ${META_SIGMA_DIR}/mk/sstate-server.mk

###### internal overrides

ifneq (${BUILDVARS},)
  include ${BUILDVARS}
endif

-include ${META_SIGMA_DIR}/mk/ci.mk

endif				# NO_LATE_IMPORTS
