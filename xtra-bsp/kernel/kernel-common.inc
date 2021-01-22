## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "29c52025152bab4c557d8174da58f1a4c8e70438"
SRCREV_kernel_vanilla_4.19 ?= "54354bc5e2a599518c25769b56d76eabe94e67c9"
SRCREV_kernel_vanilla_5.4  ?= "5e1942063dc3633f7a127aa2b159c13507580d21"
SRCREV_kernel_vanilla_5.10 ?= "2d18b3ee633e0c9d7ddcaa489299113fb88ea672"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "b732e14e6218bd925e15c539165f037081ae5176"
SRCREV_kernel_uapihdr_4.19 ?= "c1f49fb15943656d5e1a3bd696853ab3a954babb"
SRCREV_kernel_uapihdr_5.4  ?= "1f58e378a17e82e30cf9985a8ea5a738d65775b9"
SRCREV_kernel_uapihdr_5.10 ?= "c48f69093e5e36201ca3a3178e591d0f02ae54de"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
