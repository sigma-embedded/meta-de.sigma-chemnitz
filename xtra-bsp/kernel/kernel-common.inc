## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "3949d16100044eeb6723eca03b1038b469fb9ae8"
SRCREV_kernel_vanilla_4.19 ?= "b17faf2c4e88ac0deb894f068bda67ace57e9c0a"
SRCREV_kernel_vanilla_5.4  ?= "90245959a5b936ee013266e5d1e6a508ed69274e"
SRCREV_kernel_vanilla_5.10 ?= "8d823aaa220eebec88c9f307225d3e163252ea95"
SRCREV_kernel_vanilla_5.15 ?= "9cf4111cdf9420fa99792ae16c8de23242bb2e0b"
SRCREV_kernel_vanilla_6.1  ?= "68a95455c153f8adc513e5b688f4b348daa7c1b1"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "94fd62e764935aaf2689c2737c921cd22a9103c1"
SRCREV_kernel_uapihdr_4.19 ?= "f787f811115bb0676bc4a11fb1d1dcc54ec2d136"
SRCREV_kernel_uapihdr_5.4  ?= "6a54d033372d2272e0e5b710df752dc5ad29e850"
SRCREV_kernel_uapihdr_5.10 ?= "743435cd1705b4a3a4b8e73a538c4c1a1efc7edb"
SRCREV_kernel_uapihdr_5.15 ?= "033636b32258de679fd990717528eed45b104a0d"
SRCREV_kernel_uapihdr_6.1  ?= "dc1ccb4c0f850038a35eddc919a65b3131925a6c"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"
SRCREV_kernel_6.1  ?= "${SRCREV_kernel_vanilla_6.1}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
