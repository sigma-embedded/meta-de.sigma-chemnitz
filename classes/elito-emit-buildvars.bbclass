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

_BUILDVARS_cargo = "\
    ~CARGO \
    ~CARGO_BUILD_FLAGS \
    ~CARGO_BUILD_TARGET \
    ~CARGO_HOME \
    ~CARGO_TARGET_SUBDIR \
\
    ~RUSTFLAGS \
    ~RUSTLIB \
    ~RUST_TARGET_PATH \
    ~RUST_BUILD_SYS \
    ~RUST_HOST_SYS \
    ~RUST_TARGET_SYS \
\
    ~RUST_BUILD_AR \
    ~RUST_BUILD_CC \
    ~RUST_BUILD_CCLD \
    ~RUST_BUILD_CXX \
\
    ~RUST_TARGET_AR \
    ~RUST_TARGET_CC \
    ~RUST_TARGET_CCLD \
    ~RUST_TARGET_CXX \
"

_BUILDVARS_cmake = "\
    ~EXTRA_OECMAKE \
    ~OECMAKE_C_FLAGS \
    ~OECMAKE_GENERATOR_ARGS \
"

_BUILDVARS_kernel-arch = "\
    ~KERNEL_AR \
    ~KERNEL_CC \
    ~KERNEL_LD \
"

_BUILDVARS_meson = "\
    ~MESONOPTS \
    ~MESON_CROSS_FILE \
"

_BUILDVARS_pkgconfig = "\
    PKG_CONFIG_DIR \
    PKG_CONFIG_LIBDIR \
    PKG_CONFIG_PATH \
    PKG_CONFIG_SYSROOT_DIR \
    PKG_CONFIG_DISABLE_UNINSTALLED \
    PKG_CONFIG_SYSTEM_LIBRARY_PATH \
    PKG_CONFIG_SYSTEM_INCLUDE_PATH \
"

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
    OBJCOPY \
    OBJDUMP \
    RANLIB \
    STRIP \
\
    PYTHON \
    PYTHON_LIBRARY \
    PYTHON_INCLUDE_DIR \
\
    ?CCACHE \
    ?CCACHE_DIR \
\
    EXTRA_OEMAKE \
    EXTRA_OECONF \
\
    CONFIGUREOPTS \
\
    ~ACLOCALDIR \
    ~ACLOCALEXTRAPATH \
\
    ~HOST_PREFIX \
    ~TARGET_PREFIX \
    MACHINE \
    PATH \
    ?S \
    ?B \
    DEPLOY_DIR \
    DEPLOY_DIR_IMAGE \
    PN \
    PV \
    ~STAGING_DIR_HOST \
    STAGING_DIR_NATIVE \
    ~STAGING_DIR_TARGET \
    STAGING_DATADIR_NATIVE \
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
    base_libdir \
    libexecdir \
    datadir \
\
    ${_BUILDVARS_cargo} \
    ${_BUILDVARS_cmake} \
    ${_BUILDVARS_kernel-arch} \
    ${_BUILDVARS_meson} \
    ${_BUILDVARS_pkgconfig} \
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

BUILDVARS_MINIFY ?= "true"
BUILDVARS_MINIFY[type] = "boolean"
BUILDVARS_MINIFY[doc] = "When set, minify output by substituting common paths \
in the output"

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

BUILDVARS_STYLE[type] = "string"
BUILDVARS_STYLE[doc] = "Buildvars style; supported values are _autotools_, \
    _meson_ and _qmake'"

SSTATETASKS += "do_emit_buildvars"

## Splite BUILDVARS_EXPORT and honor special prefixes
def _emitbuildvars_split_vars(d):
    import re

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

        def __replace_val(self, val, prefix):
            for (pat, repl) in replacements:
                if self.name == repl:
                    continue
                val = pat.sub('${' + prefix + repl + '}', val)

            return val

        def emit(self, d, prefix):
            val = d.getVar(self.name, True)
            if self.is_dflt:
                eq = ' ?='
            else:
                eq = ' ='

            start = prefix + self.name + eq

            if val:
                val = val.strip()

            if val:
                if do_minify:
                    val = self.__replace_val(val, prefix)
                return start + ' ' + val
            elif not self.is_optional:
                raise Exception("emit-buildvars: variable '%s' not set" % self.name)
            elif self.emit_null:
                return start
            else:
                return None

    def genpair(d, varname):
        return (d.getVar(varname), varname)

    def fixup_replacement(replacements):
        seen = set()
        tmp = []
        for (pat, repl) in replacements:
            ## filter out already seen and empty patterns
            if pat in seen or not pat:
                continue

            seen.add(pat)
            tmp.append((pat, repl))

        ## move longest pattern first
        tmp = sorted(tmp, key = lambda k: len(k[0]), reverse = True)

        res = []
        for (pat, repl) in tmp:
            pat = re.compile(re.escape(pat) + r'\b')
            res.append((pat, repl))

        return res

    res = {}
    do_minify = oe.data.typed_value('BUILDVARS_MINIFY', d)

    ## put common dirs first; they will take precedence over those
    ## declared later
    replacements = fixup_replacement([
        genpair(d, 'TMPDIR'),
        genpair(d, 'DEPLOY_DIR'),
        genpair(d, 'WORKDIR'),
        genpair(d, 'STAGING_DIR_NATIVE'),
        genpair(d, 'STAGING_DIR_TARGET'),
        genpair(d, 'S'),
        genpair(d, 'B'),
    ])

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

def _get_buildvars_style(d):
    style = d.getVar('BUILDVARS_STYLE', True)

    if style and len(style) > 0:
        return style

    for k in ('autotools', 'meson', 'cargo'):
        if bb.data.inherits_class(k, d):
            return '_%s_' % k

    return None

_get_vardeps[vardeps] += 'BUILDVARS_EXPORT'
def _get_vardeps(d):
    res = set()
    for name in oe.data.typed_value('BUILDVARS_EXPORT', d):
        while name:
            if name[0] in ['-', '?', '!']:
                name = name[1:]
            else:
                break

        res.add(name)

    return ' '.join(sorted(res))

do_emit_buildvars[vardeps] += "\
    ${@_get_vardeps(d)} \
    BUILDVARS_OMIT_FOOTER BUILDVARS_FOOTER \
    BUILDVARS_PREFIX BUILDVARS_STYLE BUILDVARS_MINIFY \
    _get_vardeps \
    _emitbuildvars_split_vars _get_buildvars_style"
do_emit_buildvars[dirs] = "${BUILDVARSDIR}"
do_emit_buildvars[sstate-inputdirs] = "${BUILDVARSDIR}"
do_emit_buildvars[sstate-outputdirs] = "${BUILDVARS_DEPLOY_DIR}"
python do_emit_buildvars() {
    class RawString:
        def __init__(self, name, eq, v):
            self.v = v
            self.eq = eq
            self.name = name

        def emit(self, d, prefix):
            return '%s%s %s %s' % (prefix, self.name, self.eq, self.v)

    res = []
    style = _get_buildvars_style(d)

    prefix = d.getVar("BUILDVARS_PREFIX", True)
    values = _emitbuildvars_split_vars(d)

    if style:
        style = RawString('BUILDVARS_STYLE', '?=', style)
        values[style.name] = style

    for name in sorted(values):
        val = values[name].emit(d, prefix)
        if val:
            res.append(val)

    if not oe.data.typed_value('BUILDVARS_OMIT_FOOTER', d):
        res.extend(['',
                    'ifdef _BUILDVAR_STYLE',
                    'include ${%sBUILDVARS_SCRIPT_DIR}/${_BUILDVAR_STYLE}.mk' % prefix])

        if style:
            res.extend(['else ifneq (${%s%s},)' % (prefix, style.name),
                        'include ${%sBUILDVARS_SCRIPT_DIR}/${%s%s}.mk' % (prefix, prefix, style.name)])

        res.extend(['endif'])

    fname = d.expand("${BUILDVARSDIR}/${PN}.mk")
    with open(fname, "w") as f:
        f.write('\n'.join(res))

}
addtask do_emit_buildvars after do_prepare_recipe_sysroot

do_emit_buildvars_rec[noexec] = "1"
do_emit_buildvars_rec() {
}
addtask do_emit_buildvars_rec

python() {
    if oe.data.typed_value('BUILDVARS_EMIT', d):
        bb.build.addtask("emit_buildvars", "do_build", None, d)
        bb.build.addtask("emit_buildvars", "do_emit_buildvars_rec", None, d)
}
