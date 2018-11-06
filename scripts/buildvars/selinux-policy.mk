include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

MODULE_PRIO ?= 800
POLICY_FILE ?= policy.31
POLICY_FILE_SRC = ${BUILDVAR_SE_POLICY_ROOT}/etc/selinux/${BUILDVAR_SE_POLICY_NAME}/policy/${POLICY_FILE}

SEMODULE = semodule \
  -p '${BUILDVAR_SE_POLICY_ROOT}' \
  -s '${BUILDVAR_SE_POLICY_NAME}' \
  -n

modules: | .stamp-selinux-dir
	${MAKE} ${BUILDVAR_SE_OEMAKE} all

policy:	modules
	${MAKE} -f ${firstword ${MAKEFILE_LIST}} .stamp-policy

.stamp-policy:	${POLICY_FILE}
	@touch $@

${POLICY_FILE}:	${POLICY_FILE_SRC}
	install -p -m 0644 $< $@

${POLICY_FILE_SRC}:	$(wildcard *.pp)
	${SEMODULE} -X ${MODULE_PRIO} -i *.pp
	rm -rf ${BUILDVAR_SE_POLICY_ROOT}/var/lib/selinux/${BUILDVAR_SE_POLICY_NAME}/active/modules/${MODULE_PRIO}

.stamp-selinux-dir:
	rm -rf .selinux
	mkdir -p .selinux
	ln -s ${BUILDVAR_SE_HEADERDIR} .selinux/inc
	@touch $@

.PHONY:	modules policy
