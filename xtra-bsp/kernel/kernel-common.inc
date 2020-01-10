## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ?= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC ?= ";branch=linux-${BASE_PV}.y"
#KERNEL_REFSPEC ?= ";branch=master"
KERNEL_URI ?= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "b0cdffaa546e24acf92ab3b0d4e917a51aff6a82"
SRCREV_kernel_vanilla_4.19 ?= "cb1f9a169a0e197f93816ace48a6520e8640809d"
SRCREV_kernel_vanilla_5.4  ?= "7a02c193298ec15f2ba1344b6bcd5d578a41b2e0"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "a46102f47dfe7da531facb9eacc5020e86ae7229"
SRCREV_kernel_uapihdr_4.19 ?= "aedc1c75ff6affa30e37e7d1a3a48d6686eefe6f"
SRCREV_kernel_uapihdr_5.4  ?= "dc857d605bb8c66ca8f1082e173e97406c5b3bf1"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
