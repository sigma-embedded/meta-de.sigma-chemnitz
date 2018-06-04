ci-deploy ci-deploy-rescue ci-deploy-sdk ci-deploy-doc:
	: D=$(abspath $D)
	: PWD=$(abspath .)
	rm -rf $D
	mkdir -p $D
	$(MAKE) .$@ BUILDMODE=ci BUILDVARS='${BUILDVARS}'
	ls -l "$D"/

ci-build:
	$(MAKE) .$@ BUILDMODE=ci BUILDDIR="../build${CI_FLAVOR}-${CI_DIST}" C="build${CI_FLAVOR}" top_srcdir="$(abspath .)"

ifeq (${BUILDMODE},ci)
override BUILDMODE = .ci
T ?= image

.ci-deploy .ci-deploy-sdk .ci-build:%:				.%-pre .% .%-post
..ci-deploy-pre ..ci-deploy-sdk-pre ..ci-build-pre:%-pre:
..ci-deploy-post ..ci-deploy-sdk-post ..ci-build-post:%-post:	%
..ci-deploy ..ci-deploy-sdk ..ci-build:%:			%-pre

..ci-deploy:
	ln $S/images/*/* $D/

..ci-deploy-sdk:
	ln $S/sdk/* $D/

..ci-build:		.ci-prepare
	$(MAKE) $T
	touch ${BUILDDIR}/conf/.ok
	${CI_DIR}/source-distribute /cache/sources
	$(MAKE) "ci-deploy${CI_FLAVOR}" D="_deploy${CI_FLAVOR}" S=${BUILDDIR}/deploy

.ci-prepare:	tmpl.conf
ifneq ($(CI_FLAVOR),)
	ln -s build "build${CI_FLAVOR}"
endif
	${CI_DIR}/oe-conf "$C" "${BUILDDIR}" "$(abspath $<)" "local-local.conf" 0
ifneq (${CI_MACHINE},)
	sed -i -e "1i\\" -e "MACHINE = \"${CI_MACHINE}\"" ${BUILDDIR}/conf/local.conf
endif

endif				# BUILDMODE == ci
