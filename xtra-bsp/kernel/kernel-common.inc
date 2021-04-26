## --*- bitbake -*--
LICENSE = "GPLv2"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "ad8397a84e1e425e3f8221638cee2bfa237d9b2c"
SRCREV_kernel_vanilla_4.19 ?= "6b7b0056defc6eb5c87bbe4690ccda547b2891aa"
SRCREV_kernel_vanilla_5.4  ?= "103f1dbea1ae44731edca02cd7fcfa4a33742cd2"
SRCREV_kernel_vanilla_5.10 ?= "33069919e2dce440d3b8cd101b18f37bb35bdddf"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "9c1fbf6d3ef2ad60292660ba3d0c48184ee3239a"
SRCREV_kernel_uapihdr_4.19 ?= "20bff2f8c3e47d17214126e39db88747f7fd7399"
SRCREV_kernel_uapihdr_5.4  ?= "9e3cbdc52318ae4e40fa88ade746b29def80ce0f"
SRCREV_kernel_uapihdr_5.10 ?= "75ea982469035153cd494337b0de0f09b8e5bdf2"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
