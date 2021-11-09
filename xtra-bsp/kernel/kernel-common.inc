## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "cd529693461026636f76d0395a42cb2439bbd368"
SRCREV_kernel_vanilla_4.19 ?= "38ec06730e44b2166e87fecca9e36380080801ac"
SRCREV_kernel_vanilla_5.4  ?= "89b6869b942b8730467f2a0760ea466044aa52d2"
SRCREV_kernel_vanilla_5.10 ?= "378e85d1aeb5c93db43f2089630ec40c7385bd54"
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

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""
