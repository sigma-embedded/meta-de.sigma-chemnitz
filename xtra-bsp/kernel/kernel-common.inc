## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "4520f06b03ae667e442da1ab9351fd28cd7ac598"
SRCREV_kernel_vanilla_4.19 ?= "dda0e2920330128e0dbdeb11c8f25031aa40b11c"
SRCREV_kernel_vanilla_5.4  ?= "de850633a01fa06515a89a184d6e9769c160d932"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "d3dbedd4b90bcc9c53d5cdc3de7fe3ab55727c59"
SRCREV_kernel_uapihdr_4.19 ?= "74d0c209f93bfcd8b4c291a91d1bfe67625164c9"
SRCREV_kernel_uapihdr_5.4  ?= "1843cba24aefd799701d35ea4c0dc3b467f6eaa7"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
