# Emits bitbake variables into makefile fragments.  This class can be
# used either globally in INHERIT and buildvar export can be requested
# manually by
#
#  $ bitbake u-boot -c emit_buildvars
#
# Or, it can be inheritted in bbappend files like
#
#  BUILDVARS_EMIT = "true"
#  inherit emit-buildvars
#
# The class defines ${BUILDVARS_EXPORT} which is a list of variables
# to be exported. It can be extended in .bbappend files.
#
# It will create a file ${PN}.mk in 'deploy/buildvars/${MACHINE}'
# which contains something like
#
#  BUILDVAR_AR = arm-oe-linux-gnueabi-ar
#  BUILDVAR_BUILD_AR = ar
#  BUILDVAR_BUILD_CC = ccache gcc
#  ...
#
# These .mk files can be included by other Makefiles which set variables
# used in their rules:
#
#  --------------
#  include ${DEPLOY_DIR}/buildvars/${MACHINE}/u-boot.mk
#
#  export PATH := ${BUILDVAR_PATH}:${PATH}
#  BUILD_FLAGS = \
#	CROSS_COMPILE='${BUILDVAR_TARGET_PREFIX}' \
#	CC='${BUILDVAR_KERNEL_CC} ${BUILDVAR_TOOLCHAIN_OPTIONS}' \
#	LD='${BUILDVAR_KERNEL_LD} ${BUILDVAR_TOOLCHAIN_OPTIONS}' \
#
#  all:
#
#  %:
#	${MAKE} ${BUILD_FLAGS} $@
#
#  shell:
#	${SHELL}
# ---------------

BUILDVARS_PREFIX ?= "BUILDVAR_"
BUILDVARS_PREFIX[type] = "string"
BUILDVARS_PREFIX[doc] = "A string prepended to the variable name."

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
	?CCACHE \
	?CCACHE_DIR \
\
	EXTRA_OEMAKE \
	EXTRA_OECONF \
\
	CONFIGUREOPTS \
\
	PKG_CONFIG_DIR \
	PKG_CONFIG_LIBDIR \
	PKG_CONFIG_PATH \
	PKG_CONFIG_SYSROOT_DIR \
\
	HOST_PREFIX \
	TARGET_PREFIX \
	MACHINE \
	PATH \
	S \
	B \
	PN \
	STAGING_DIR_HOST \
	STAGING_DIR_NATIVE \
	STAGING_DIR_TARGET \
	TMPDIR \
	TOOLCHAIN_OPTIONS \
	WORKDIR \
	?BUILDVARS_SCRIPT_DIR \
	?BUILDVARS_DEPLOY_DIR \
\
	prefix \
	bindir \
	sbindir \
	libdir \
	baselibdir \
	libexecdir \
	datadir \
"
BUILDVARS_EXPORT[type] = "list"
BUILDVARS_EXPORT[doc] = "A list of variables which shall be exported. \
A prefix '!' makes the variable mandatory; e.g. when not defined, an \
exception will be raised.  A prefix of '~' will not emit the variable \
when it is not defined.  With '?' prefix, assignment will be done with \
'?=' instead of '='"

BUILDVARS_EMIT ?= "false"
BUILDVARS_EMIT[type] = "boolean"
BUILDVARS_EMIT[doc] = "When set, the do_emit_buildvars task will be\
executed implicitly."

BUILDVARS_OMIT_FOOTER ?= "false"
BUILDVARS_OMIT_FOOTER[type] = "boolean"
BUILDVARS_OMIT_FOOTER[doc] = "When set, omit the 'ifdef' block at the\
end of the file which includes common rules."

BUILDVARS_SCRIPT_DIR ?= "${COREBASE}/scripts/buildvars"
BUILDVARS_SCRIPT_DIR[type] = "path"
BUILDVARS_SCRIPT_DIR[doc] = "Directory with common make rules."

BUILDVARS_DEPLOY_DIR = "${DEPLOY_DIR}/buildvars/${MACHINE}"
BUILDVARS_DEPLOY_DIR[type] = "path"
BUILDVARS_DEPLOY_DIR[doc] = "The path where buildvar makefiles will \
be written into."

BUILDVARSDIR = "${WORKDIR}/buildvars-${PN}"

SSTATETASKS += "do_emit_buildvars"

## Splite BUILDVARS_EXPORT and honor special prefixes
def _emitbuildvars_split_vars(d):
    class Var:
        def __init__(self, v):
            self.is_optional = True
            self.emit_null = True
            self.is_dflt = False
            while v:
                if v[0] == '~':
                    self.emit_null = False
                elif v[0] == '?':
                    self.is_dflt = True
                elif v[0] == '!':
                    self.is_optional = False
                else:
                    break

                v = v[1:]

            self.name = v

        def emit(self, d, prefix):
            val = d.getVar(self.name, True)
            if self.is_dflt:
                eq = ' ?='
            else:
                eq = ' ='

            start = prefix + self.name + eq

            if val is not None:
                return start + ' ' + val.strip()
            elif not self.is_optional:
                raise Exception("emit-buildvars: variable '%s' not set" % self.name)
            elif self.emit_null:
                return start
            else:
                return None

    res = {}
    for name in oe.data.typed_value('BUILDVARS_EXPORT', d):
        var = Var(name)
        res[var.name] = var

    return res

## Generate 'vardepvalue' consisting of concatenated list of expanded
## values.  Plain vardeps does not work due to whitelisting of TMPDIR
## and friends.
def _gen_emitbuildvars_value(d):
    res = ""
    vars = _emitbuildvars_split_vars(d)
    for v in sorted(vars.keys()):
        res += d.getVar(v, False) or ""
        res += '\0'
    return res

do_emit_buildvars[vardeps] += "BUILDVARS_EXPORT ${BUILDVARS_EXPORT} \
  BUILDVARS_OMIT_FOOTER BUILDVARS_FOOTER"
do_emit_buildvars[vardepvalue] += "${@_gen_emitbuildvars_value(d)}"
do_emit_buildvars[dirs] = "${BUILDVARSDIR}"
do_emit_buildvars[sstate-inputdirs] = "${BUILDVARSDIR}"
do_emit_buildvars[sstate-outputdirs] = "${BUILDVARS_DEPLOY_DIR}"
python do_emit_buildvars() {
    res = []
    prefix = d.getVar("BUILDVARS_PREFIX", True)
    values = _emitbuildvars_split_vars(d)
    for name in sorted(values):
        val = values[name].emit(d, prefix)
        if val:
            res.append(val)

    if not oe.data.typed_value('BUILDVARS_OMIT_FOOTER', d):
        res.extend(['',
                    'ifdef _BUILDVAR_STYLE',
                    'include ${%sBUILDVARS_SCRIPT_DIR}/${_BUILDVAR_STYLE}.mk' % prefix,
                    'endif'])

    fname = d.expand("${BUILDVARSDIR}/${PN}.mk")
    with open(fname, "w") as f:
        f.write('\n'.join(res))

}
addtask do_emit_buildvars after do_prepare_recipe_sysroot

python() {
    if oe.data.typed_value('BUILDVARS_EMIT', d):
        bb.build.addtask("emit_buildvars", "do_build", None, d)
}
