## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "46914f96189be290174e378c6bf9ccadfdb9ca1e"
SRCREV_kernel_vanilla_4.19 ?= "5c66974a63046780925e5d99b6dc6631fe2f9a31"
SRCREV_kernel_vanilla_5.4  ?= "e350cd02e293be9a6b93398b2d3ff1edf7695ab2"
SRCREV_kernel_vanilla_5.10 ?= "1cd6e30b83d741562b55bf5b7763b1238a91150c"
SRCREV_kernel_vanilla_5.14 ?= "bbdd3de144fc142f2f4b9834c9241cc4e7f3d3fc"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "6ae141218d681ffccc477959c3bcc8a5dbe9969a"
SRCREV_kernel_uapihdr_4.19 ?= "cba5008c8581a5cdebf62b1d4699148c606ab423"
SRCREV_kernel_uapihdr_5.4  ?= "bba660a079a9e7ff3809a688d5c9fdf5a377c6bf"
SRCREV_kernel_uapihdr_5.10 ?= "5cc0cf735f13b9021b33e14941fc4c719da14384"
SRCREV_kernel_uapihdr_5.14 ?= "d5ae8d7f85b7f6f6e60f1af8ff4be52b0926fde1"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.14 ?= "${SRCREV_kernel_vanilla_5.14}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""
