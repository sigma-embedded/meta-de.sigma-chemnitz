## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "eb045674aab31aa55a4f9aec27cce36e3d946a21"
SRCREV_kernel_vanilla_4.19 ?= "6b481672f19259632a852d013cacd5655e8d7da8"
SRCREV_kernel_vanilla_5.4  ?= "70f77a2cb5281ad0b08a0bbdeeba885984c399dd"
SRCREV_kernel_vanilla_5.10 ?= "327f1e7d813c77eceadafbdc498f5eb680fd9fb2"
SRCREV_kernel_vanilla_5.15 ?= "b9a0208cb3e3e37def2abe4d602f084e0f746419"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "24fb6fbe7ec004459b3c3cabe82ff8c13146e7d0"
SRCREV_kernel_uapihdr_4.19 ?= "a472c95af5f64296fc9bdbabcd2b11703bb3a205"
SRCREV_kernel_uapihdr_5.4  ?= "35fa6f2a31d332e856a7a313f745ae5ae68bf720"
SRCREV_kernel_uapihdr_5.10 ?= "0e188fde82d7c80a6301954fbfb398ddaa8647c3"
SRCREV_kernel_uapihdr_5.15 ?= "aa6d3eef28f348f1fed15e9ebac9752f93b8a9b9"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""
