__SKIPPED := "1"

require recipes-bsp/barebox/barebox.inc

GIT_URL = "git://git.phytec.de/${PN};branch=${BRANCH}"

S = "${WORKDIR}/git"

BAREBOX_LOCALVERSION = "-${BSP_VERSION}"

MACHINE_VARIANTS[type] = "list"

MAP ?= ""
MAP[type] = "list"

IMAGE_SUFFIX ?= "-${PKGV}-${PKGR}-${DATETIME}"
IMAGE_SUFFIX[vardepsexclude] += "DATETIME"

_INSTALL_CMD[vardeps] += "IMAGE_SUFFIX"
_INSTALL_CMD = "${@'\n\
\tinstall -p -m 0644 ${B}/images/%%(base)s.img %s/%%(dest)s${IMAGE_SUFFIX}.img\n\
\tln -sf %%(dest)s${IMAGE_SUFFIX}.img %s/%%(dest)s.img\
'}"

get_image_map[vardeps] += "MACHINE_VARIANTS MAP"
def get_image_map(d):
    machines = map(lambda x: x.split(':'),
                   oe.data.typed_value('MACHINE_VARIANTS', d))
    maps     = dict(map(lambda x: x.split(':'),
                    oe.data.typed_value('MAP', d)))
    res      = map(lambda x: { 'base' : '%s' % maps[ '%s_%s' % (x[0], x[2])],
                               'dest' : 'barebox-%s-%s' % (x[0], x[2]) },
                   machines)
    return res

get_install_cmds[vardeps] += "_INSTALL_CMD get_image_map"
def get_install_cmds(d, dstdir):
    cmd = d.getVar('_INSTALL_CMD', False) % (dstdir, dstdir)

    return '\n'.join(map(lambda x: cmd % x, get_image_map(d)))

do_install_append[vardeps] += "get_install_cmds"
do_install_append() {
    ${@get_install_cmds(d, '${D}${base_bootdir}')}
    :
}

do_deploy_append[vardeps] += "get_install_cmds"
do_deploy_append () {
    ${@get_install_cmds(d, '${DEPLOYDIR}')}
    :
}
