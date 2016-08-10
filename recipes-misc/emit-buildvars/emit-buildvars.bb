LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = ""
INHIBIT_DEFAULT_DEPS = "1"

vars = "\
	MACHINE \
	TMPDIR \
	STAGING_DIR_NATIVE \
	STAGING_DIR_HOST \
	CC \
	CXX \
	CFLAGS \
	CXXFLAGS \
	LDFLAGS \
	BUILD_CC \
	BUILD_CXX \
	BUILD_CFLAGS \
	BUILD_CXXFLAGS \
	BUILD_LDFLAGS \
	PATH \
"

expand_vars[vardeps] = "vars ${vars}"
def expand_vars(d):
    res = []
    for v in sorted(d.getVar('vars', True).split()):
        res.append('BUILDVAR_%s = %s' % (v, d.getVar(v, True)))

    return res

inherit deploy

do_compile() {
    echo "${@'\n'.join(expand_vars(d))}" > build-vars.mk
}

do_deploy() {
    install -D -p -m 0644 build-vars.mk ${DEPLOYDIR}/build-vars.mk
}
addtask do_deploy after do_compile
