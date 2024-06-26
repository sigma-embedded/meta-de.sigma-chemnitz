## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""

BUILDVARS_EXPORT += "\
    ARCH \
    CROSS_COMPILE \
    KERNEL_AR \
    KERNEL_CC \
    KERNEL_LD \
"
