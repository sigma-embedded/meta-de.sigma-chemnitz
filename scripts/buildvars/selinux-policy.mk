include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

MODULE_PRIO ?= 800
POLICY_FILE ?= policy.33
POLICY_FILE_SRC = ${BUILDVAR_SE_POLICY_ROOT}/etc/selinux/${BUILDVAR_SE_POLICY_NAME}/policy/${POLICY_FILE}

FCTX_FILE ?= file_contexts
FCTX_FILE_SRC = ${BUILDVAR_SE_POLICY_ROOT}/etc/selinux/${BUILDVAR_SE_POLICY_NAME}/contexts/files/file_contexts

SEMODULE = semodule \
  -p '${BUILDVAR_SE_POLICY_ROOT}' \
  -s '${BUILDVAR_SE_POLICY_NAME}' \
  -n

modules: | .stamp-selinux-dir
	${MAKE} ${BUILDVAR_SE_OEMAKE} all

policy:	modules
	${MAKE} -f ${firstword ${MAKEFILE_LIST}} .stamp-policy

.stamp-policy:	${POLICY_FILE} ${FCTX_FILE}
	@touch $@

${POLICY_FILE}:	${POLICY_FILE_SRC}
	install -p -m 0644 $< $@

${FCTX_FILE}:	${FCTX_FILE_SRC}
	install -p -m 0644 $< $@

${POLICY_FILE_SRC}:	$(addsuffix .pp,${BUILDVAR_SE_LOCAL_POLICY_MODULES})
	${SEMODULE} -X ${MODULE_PRIO} -i $^
	${SEMODULE} -B
	rm -rf ${BUILDVAR_SE_POLICY_ROOT}/var/lib/selinux/${BUILDVAR_SE_POLICY_NAME}/active/modules/${MODULE_PRIO}

.stamp-selinux-dir:
	rm -rf .selinux
	mkdir -p .selinux
	ln -s ${BUILDVAR_SE_HEADERDIR} .selinux/inc
	@touch $@

.PHONY:	modules policy
