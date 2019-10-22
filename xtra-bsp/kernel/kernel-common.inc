## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ?= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC ?= ";branch=linux-${BASE_PV}.y"
#KERNEL_REFSPEC ?= ";branch=master"
KERNEL_URI ?= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "ddef1e8e3f6eb26034833b7255e3fa584d54a230"
SRCREV_kernel_vanilla_4.19 ?= "ddef1e8e3f6eb26034833b7255e3fa584d54a230"
SRCREV_kernel_vanilla_5.2  ?= "e91ef5bcdeda8956eb9f1972ed90198b698dca0f"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "a46102f47dfe7da531facb9eacc5020e86ae7229"
SRCREV_kernel_uapihdr_4.19 ?= "4e5fbcb9a61581747504c9e90dd494f62379c4db"
SRCREV_kernel_uapihdr_5.2  ?= "7844dde203db2656bb32849764fb48dc140c4cd6"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.2  ?= "${SRCREV_kernel_vanilla_5.2}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
