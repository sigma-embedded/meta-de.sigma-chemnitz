def find_cfgs(d):
    sources=src_patches(d, True)
    sources_list=[]
    for s in sources:
        if s.endswith('.cfg'):
            sources_list.append(s)

    return ' '.join(sources_list)

CFG_SRC = "${@find_cfgs(d)}"

KCONFIG_DEFCONFIG ?= "${WORKDIR}/defconfig"

kernel_do_configure() {
	touch ${B}/.scmversion ${S}/.scmversion

	rm -f ${B}/.config

	touch .empty.cfg

	${S}/scripts/kconfig/merge_config.sh -m -O ${B} \
		"${KCONFIG_DEFCONFIG}" .empty.cfg ${CFG_SRC}

	${KERNEL_CONFIG_COMMAND}
}

do_kconfig_savedefconfig[dirs] = "${B}"
do_kconfig_savedefconfig() {
	oe_runmake savedefconfig
	test -s defconfig
}
addtask do_kconfig_savedefconfig after do_configure

do_kconfig_emit_buildhistory() {
	if "${@bb.utils.contains('INHERIT', 'buildhistory', 'true', 'false', d)}" && \
           "${@bb.utils.contains('BUILDHISTORY_FEATURES', 'image', 'true', 'false', d)}"; then
		install -D -p -m 0644 ${B}/.config   ${BUILDHISTORY_DIR_IMAGE}/${PN}-config
		install -D -p -m 0644 ${B}/defconfig ${BUILDHISTORY_DIR_IMAGE}/${PN}-defconfig
	fi
}
addtask do_kconfig_emit_buildhistory after do_kconfig_savedefconfig before do_build
