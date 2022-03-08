## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "a35d65bedfbc38cffe2701798cd6810bbdf07892"
SRCREV_kernel_vanilla_4.19 ?= "62a337a490a121949fc939a29f5ae1da94871b16"
SRCREV_kernel_vanilla_5.4  ?= "7b3eb66d0daf61e91cccdb2fe5d271ae5adc5a76"
SRCREV_kernel_vanilla_5.10 ?= "3969aba589d663b2a704f31555c2caead75a1646"
SRCREV_kernel_vanilla_5.15 ?= "a0ebea480bb319a3ad408c99db91262dbc696b76"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "6456e34572939af0355dcf05e654dfcdc57e8b90"
SRCREV_kernel_uapihdr_4.19 ?= "89a258431c3e4776b2ded618085d366a27c27277"
SRCREV_kernel_uapihdr_5.4  ?= "b364fcef9615eb8084d6c16b5b649a0070c49d9a"
SRCREV_kernel_uapihdr_5.10 ?= "04fe6569a7cfb1040a0f41b9e2a0d89d7f2d8529"
SRCREV_kernel_uapihdr_5.15 ?= "c5ee4cbd0f1bd729bc417ba72bc29c835f9b0e08"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
