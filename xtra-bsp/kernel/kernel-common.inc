## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "424a46ea058e160ae6fdd0693092ba79da533f26"
SRCREV_kernel_vanilla_4.19 ?= "e8b2a9c3318357b7661c6075acdb723587def656"
SRCREV_kernel_vanilla_5.4  ?= "6584107915561f860b7b05dcca5c903dd62a308d"
SRCREV_kernel_vanilla_5.10 ?= "8f95261a006489c828f1d909355669875649668b"
SRCREV_kernel_vanilla_5.15 ?= "baefa2315cb1371486f6661a628e96fa3336f573"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "aa38e379f95e5c4fc5a6eff48f5d73aac1422986"
SRCREV_kernel_uapihdr_4.19 ?= "a0d109cfe641a59d004552ff96bf8b7aaa4dbd6e"
SRCREV_kernel_uapihdr_5.4  ?= "c4edc1055c1171f0d84183eb70f855bd3346e0e7"
SRCREV_kernel_uapihdr_5.10 ?= "633be494c3ca66a6c36e61100ffa0bd3d2923954"
SRCREV_kernel_uapihdr_5.15 ?= "121af0231f82c3cd79308da28c151f7db59945da"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""
