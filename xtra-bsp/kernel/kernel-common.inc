## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "9bbf62a7196364dfe558da71592663b1431cad66"
SRCREV_kernel_vanilla_4.19 ?= "cdfda37ab2cfc783a190b563806cda611c35d1e3"
SRCREV_kernel_vanilla_5.4  ?= "ea7862c507eca54ea6caad9dcfc8bba5e749fbde"
SRCREV_kernel_vanilla_5.10 ?= "f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb"
SRCREV_kernel_vanilla_5.15 ?= "8a7f2a5c5aa1648edb4f2029c6ec33870afb7a95"
SRCREV_kernel_vanilla_6.1  ?= "ca48fc16c49388400eddd6c6614593ebf7c7726a"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "62b828ad77b82ed7c7bee45aa3f7e8b02be88165"
SRCREV_kernel_uapihdr_4.19 ?= "be678ad82ef6ba4ea8a4e3c9ab27234d98267c1d"
SRCREV_kernel_uapihdr_5.4  ?= "195c1e9f454e6164ad924c34033016bfcc9f126e"
SRCREV_kernel_uapihdr_5.10 ?= "56495e8d3cb4522b8e72347755d5c02e64ac30df"
SRCREV_kernel_uapihdr_5.15 ?= "14cbfd08551af86c255095719d56f8bdc7c48510"
SRCREV_kernel_uapihdr_6.1  ?= "7a7de5957b8f86a50350e3e8a5b44a946eef0601"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"
SRCREV_kernel_6.1  ?= "${SRCREV_kernel_vanilla_6.1}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""
