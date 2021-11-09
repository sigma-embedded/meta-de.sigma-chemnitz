## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "0447aa205abe1c0c016b4f7fa9d7c08d920b5c8e"
SRCREV_kernel_vanilla_4.19 ?= "3033e5726834e4c9c8c48cdb2273f33bd105f938"
SRCREV_kernel_vanilla_5.4  ?= "c65356f0f7268b1260dd64415c2145e73640872e"
SRCREV_kernel_vanilla_5.10 ?= "5040520482a594e92d4f69141229a6dd26173511"
SRCREV_kernel_vanilla_5.15 ?= "b6abb62daa5511c4a3eaa30cbdb02544d1f10fa2"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "ec681da8f359e51966d2f7c4367135b5e67ab11e"
SRCREV_kernel_uapihdr_4.19 ?= "7c113506163a1ec6157927428eddd80038d2916e"
SRCREV_kernel_uapihdr_5.4  ?= "93f54354ccc8cffd4daea2837f7b95b6da0966a9"
SRCREV_kernel_uapihdr_5.10 ?= "8c01c620ae61142760d8924ee96a3ff8eec00aa6"
SRCREV_kernel_uapihdr_5.15 ?= "6c2c712767ee1d74b2234c9caaf1920808333be6"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
