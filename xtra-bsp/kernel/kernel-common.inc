## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "9bbf62a7196364dfe558da71592663b1431cad66"
SRCREV_kernel_vanilla_4.19 ?= "cdfda37ab2cfc783a190b563806cda611c35d1e3"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "62b828ad77b82ed7c7bee45aa3f7e8b02be88165"
SRCREV_kernel_uapihdr_4.19 ?= "be678ad82ef6ba4ea8a4e3c9ab27234d98267c1d"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""
