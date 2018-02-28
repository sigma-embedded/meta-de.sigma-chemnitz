def find_cfgs(d):
    sources=src_patches(d, True)
    sources_list=[]
    for s in sources:
        if s.endswith('.cfg'):
            sources_list.append(s)

    return ' '.join(sources_list)

CFG_SRC = "${@find_cfgs(d)}"

kernel_do_configure() {
	touch ${B}/.scmversion ${S}/.scmversion

	rm -f ${B}/.config

	${S}/scripts/kconfig/merge_config.sh -m -O ${B} \
		${WORKDIR}/defconfig ${CFG_SRC}

	${KERNEL_CONFIG_COMMAND}
}
