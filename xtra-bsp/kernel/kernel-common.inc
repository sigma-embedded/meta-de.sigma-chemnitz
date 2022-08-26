## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "e548869f356fead9fdcb3562f52d2226574f4f41"
SRCREV_kernel_vanilla_4.19 ?= "635460a42df915276628f80a77e025a9aa3aa4ad"
SRCREV_kernel_vanilla_5.4  ?= "684cc17be897de3b0fd2e5a021a702f68046d9fe"
SRCREV_kernel_vanilla_5.10 ?= "fa3303d70b423dd3e855f57febaba77e15069650"
SRCREV_kernel_vanilla_5.15 ?= "addc9003c2e895fe8a068a66de1de6fdb4c6ac60"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "f60fa2510a6405bf7bcaf05e2069610e1cb0fdcb"
SRCREV_kernel_uapihdr_4.19 ?= "e5ed6be01b2846c55a3e729a3d0a2d661853a606"
SRCREV_kernel_uapihdr_5.4  ?= "a025f6ca15b273de25f239befefc642852d58acd"
SRCREV_kernel_uapihdr_5.10 ?= "78d431e8a56ca71f58db176635ca85f5271cadd3"
SRCREV_kernel_uapihdr_5.15 ?= "154bf040ba53529a69ae063c15c0f6db3593cce4"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
