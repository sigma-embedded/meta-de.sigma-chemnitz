## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ?= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC ?= ";branch=linux-${BASE_PV}.y"
#KERNEL_REFSPEC ?= ";branch=master"
KERNEL_URI ?= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "45f092f9e9cb31486db546e39bfe7cc0b3f57099"
SRCREV_kernel_vanilla_4.19 ?= "a5aa80588fcd5520ece36121c41b7d8e72245e33"
SRCREV_kernel_vanilla_5.2  ?= "aad39e30fb9e6e7212318a1dad898f36f1075648"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "e24aea6c00ed9f8aa03b18769564321d6a1a2c02"
SRCREV_kernel_uapihdr_4.19 ?= "f2fd89817212fbbe2e67b04a4fa80f1e992ff812"
SRCREV_kernel_uapihdr_5.2  ?= "c60ab146fa9e99c52f2a5bbc2193241d4272e67c"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.2  ?= "${SRCREV_kernel_vanilla_5.2}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
