ci-deploy ci-deploy-rescue ci-deploy-sdk ci-deploy-doc:
	: D=$(abspath $D)
	: PWD=$(abspath .)
	rm -rf $D
	mkdir -p $D
	$(MAKE) .$@ BUILDMODE=ci BUILDVARS='${BUILDVARS}'
	ls -lR "$D"/

ci-build:
	$(MAKE) .$@ BUILDMODE=ci BUILDDIR="../build${CI_FLAVOR}-${CI_DIST}" C="build${CI_FLAVOR}" top_srcdir="$(abspath .)"

ifeq (${BUILDMODE},ci)
override BUILDMODE = .ci

ifeq (${CI_MULTI_MACHINE},)
T ?= image
CI_DEPLOY_MACHINES ?=
else
T ?= all-images
CI_DEPLOY_MACHINES ?= ${MACHINES}
endif

.ci-deploy .ci-deploy-sdk .ci-build:.%:				%-pre ..% %-post
ci-deploy-pre ci-deploy-sdk-pre ci-build-pre:%-pre:
ci-deploy-post ci-deploy-sdk-post ci-build-post:%-post:		..%
..ci-deploy ..ci-deploy-sdk ..ci-build:..%:			%-pre

ifeq (${CI_DEPLOY_MACHINES},)
..ci-deploy:
	ln $S/images/*/* $D/
else
..ci-deploy:	$(addprefix ci-deploy_machine-,${CI_DEPLOY_MACHINES})
endif

$(addprefix ci-deploy_machine-,${CI_DEPLOY_MACHINES}):	ci-deploy-pre

$(addprefix ci-deploy_machine-,${CI_DEPLOY_MACHINES}):ci-deploy_machine-%:
	install -d -m 0755 '$D/$*'
	ln $S/images/'$*'/* '$D/$*/'

..ci-deploy-sdk:
	ln $S/sdk/* $D/

..ci-build:		.ci-prepare
	$(MAKE) $T
	touch ${BUILDDIR}/conf/.ok
	${CI_DIR}/source-distribute /cache/sources
	$(MAKE) "ci-deploy${CI_FLAVOR}" D="_deploy${CI_FLAVOR}" S=${DEPLOY_DIR}

.ci-prepare:	tmpl.conf
ifneq ($(CI_FLAVOR),)
	ln -s build "build${CI_FLAVOR}"
endif
	${CI_DIR}/oe-conf "$C" "${BUILDDIR}" "$(abspath $<)" "local-local.conf" 0
ifneq (${CI_MACHINE},)
	sed -i -e "1i\\" -e "MACHINE = \"${CI_MACHINE}\"" ${BUILDDIR}/conf/local.conf
endif

endif				# BUILDMODE == ci
