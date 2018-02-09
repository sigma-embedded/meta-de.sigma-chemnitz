BUILDVARS_PREFIX ?= "BUILDVAR_"

BUILDVARS_EXPORT = "\
        BUILD_AR \
	BUILD_CC \
	BUILD_CFLAGS \
        BUILD_CCLD \
        BUILD_CPP \
        BUILD_CPPFLAGS \
	BUILD_CXX \
	BUILD_CXXFLAGS \
        BUILD_LD \
	BUILD_LDFLAGS \
        BUILD_NM \
        BUILD_RANLIB \
        BUILD_STRIP \
\
        AR \
	CC \
	CFLAGS \
        CCLD \
        CPP \
        CPPFLAGS \
	CXX \
	CXXFLAGS \
        LD \
	LDFLAGS \
        NM \
        RANLIB \
        STRIP \
\
        CCACHE \
        CCACHE_DIR \
\
        EXTRA_OEMAKE \
        EXTRA_OECONF \
\
	HOST_PREFIX \
	TARGET_PREFIX \
	MACHINE \
	PATH \
	S \
	STAGING_DIR_HOST \
	STAGING_DIR_NATIVE \
	STAGING_DIR_TARGET \
	TMPDIR \
	TOOLCHAIN_OPTIONS \
        WORKDIR \
"

BUILDVARSDIR = "${WORKDIR}/buildvars-${PN}"
DEPLOY_DIR_BUILDVARS = "${DEPLOY_DIR}/buildvars/${MACHINE}"

SSTATETASKS += "do_emit_buildvars"

do_emit_buildvars[vardeps] = "BUILDVARS_EXPORT ${BUILDVARS_EXPORT}"
do_emit_buildvars[dirs] = "${BUILDVARSDIR}"
do_emit_buildvars[sstate-inputdirs] = "${BUILDVARSDIR}"
do_emit_buildvars[sstate-outputdirs] = "${DEPLOY_DIR_BUILDVARS}"
python do_emit_buildvars() {
    vars = []
    prefix = d.getVar("BUILDVARS_PREFIX", True)
    for v in sorted(d.getVar('BUILDVARS_EXPORT', True).split()):
        val = (d.getVar(v, True) or "").strip()
        vars.append(('%s%s = %s' % (prefix, v, val)).strip())

    fname = d.expand("${BUILDVARSDIR}/${PN}.mk")
    with open(fname, "w") as f:
        f.write('\n'.join(vars))
}
addtask do_emit_buildvars after do_prepare_recipe_sysroot
