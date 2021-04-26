## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "cf256fbcbe347b7d0ff58fe2dfa382a156bd3694"
SRCREV_kernel_vanilla_4.19 ?= "2965db2e004cf9c92b87c1f559e9812c0ae878c1"
SRCREV_kernel_vanilla_5.4  ?= "a7eb81c1d11ae311c25db88c25a7d5228fe5680a"
SRCREV_kernel_vanilla_5.10 ?= "aea70bd5a45591de27aac367af94d184892c06ab"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "f4e7325060fe9d7f6b223fee7d2a28bf91ba8cb9"
SRCREV_kernel_uapihdr_4.19 ?= "eac35ed3f8349727259ce15f1d68ca87e1adf1a3"
SRCREV_kernel_uapihdr_5.4  ?= "c92aebf2b0f311ec19f70ebe3669a2534ef1c203"
SRCREV_kernel_uapihdr_5.10 ?= "0e3f14755111522018c0e325d1ce768dd609641a"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
