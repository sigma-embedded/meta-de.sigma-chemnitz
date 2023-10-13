## --*- bitbake -*--
HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"

LICENSE = "GPL-2.0-or-later"

UBOOT_BASE_URI ??= "git+https://github.com/u-boot/u-boot.git"
UBOOT_REFSPEC  ??= ";branch=v${BASE_PV};nobranch=1"
UBOOT_URI      ??= "${UBOOT_BASE_URI}${UBOOT_REFSPEC}"

UBOOT_LOCALVERSION ??= "${DISTRO_VERSION}"
CFG_SRC:prepend = "${WORKDIR}/local-version.cfg "

## ignore where u-boot is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "UBOOT_REFSPEC UBOOT_BASE_URI UBOOT_URI"

### NOTE: 'swig' requires a manual 'inherit python2native'

PACKAGECONFIG ??= ""
PACKAGECONFIG[swig] = ",,swig-native python3-setuptools-native"

_EXTRA_OEMAGE_swig = "\
    PYTHON2='${PYTHON}' \
    PYTHON3='${PYTHON}' \
    STAGING_INCDIR='${STAGING_INCDIR_NATIVE}' \
    STAGING_LIBDIR='${STAGING_LIBDIR_NATIVE}' \
"

EXTRA_OEMAKE += "${@bb.utils.contains('PACKAGECONFIG', 'swig', d.getVar('_EXTRA_OEMAGE_swig', False), '', d)}"

do_prepare_localversion[dirs] = "${WORKDIR}"
do_prepare_localversion() {
    rm -f 'local-version.cfg'

    if test -n '${UBOOT_LOCALVERSION}'; then
	printf 'CONFIG_LOCALVERSION=" (%s)"\n' "${UBOOT_LOCALVERSION}"
	printf '# CONFIG_LOCALVERSION_AUTO is not set\n'
    fi > local-version.cfg
}
addtask do_prepare_localversion after do_unpack before do_configure
