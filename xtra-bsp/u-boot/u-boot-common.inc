## --*- bitbake -*--
HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"

LICENSE = "GPLv2+"

UBOOT_BASE_URI ??= "git+https://github.com/u-boot/u-boot.git"
UBOOT_REFSPEC  ??= ";branch=v${BASE_PV};nobranch=1"
UBOOT_URI      ??= "${UBOOT_BASE_URI}${UBOOT_REFSPEC}"

## ignore where u-boot is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "UBOOT_REFSPEC UBOOT_BASE_URI UBOOT_URI"

### NOTE: 'swig' requires a manual 'inherit python2native'

PACKAGECONFIG ??= ""
PACKAGECONFIG[swig] = ",,swig-native"

_EXTRA_OEMAGE_swig = "\
    PYTHON2='${PYTHON}' \
    STAGING_INCDIR='${STAGING_INCDIR_NATIVE}' \
    STAGING_LIBDIR='${STAGING_LIBDIR_NATIVE}' \
"

EXTRA_OEMAKE += "${@bb.utils.contains('PACKAGECONFIG', 'swig', d.getVar('_EXTRA_OEMAGE_swig', False), '', d)}"
