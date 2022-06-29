## --*- bitbake -*--
LICENSE = "GPL-2.0-only"

KERNEL_BASE_URI ??= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_REFSPEC  ??= ";branch=linux-${BASE_PV}.y"
KERNEL_URI ??= "${KERNEL_BASE_URI}${KERNEL_REFSPEC}"

SRCREV_kernel_vanilla_4.14 ?= "f051383ef03bde49ca992f297ec80757a702e774"
SRCREV_kernel_vanilla_4.19 ?= "6a10ec7750739d143e6df5a8085fa389b3258866"
SRCREV_kernel_vanilla_5.4  ?= "9ef3ad40a81ff6b8b65ed870588b230f38812f2a"
SRCREV_kernel_vanilla_5.10 ?= "deb587b1a48d3ac4a29378fc238a4677944dff83"
SRCREV_kernel_vanilla_5.15 ?= "37238449af786e1be06f193ab54a60a39a776826"
# use separate entry for include/uapi to avoid unnecessary rebuilds of
# linux-libc-headers on kernel updates
SRCREV_kernel_uapihdr_4.14 ?= "aa38e379f95e5c4fc5a6eff48f5d73aac1422986"
SRCREV_kernel_uapihdr_4.19 ?= "a0d109cfe641a59d004552ff96bf8b7aaa4dbd6e"
SRCREV_kernel_uapihdr_5.4  ?= "c4edc1055c1171f0d84183eb70f855bd3346e0e7"
SRCREV_kernel_uapihdr_5.10 ?= "633be494c3ca66a6c36e61100ffa0bd3d2923954"
SRCREV_kernel_uapihdr_5.15 ?= "e42fd07755364329c99e51d069d2daa96df77ed7"

SRCREV_kernel_4.14 ?= "${SRCREV_kernel_vanilla_4.14}"
SRCREV_kernel_4.19 ?= "${SRCREV_kernel_vanilla_4.19}"
SRCREV_kernel_5.4  ?= "${SRCREV_kernel_vanilla_5.4}"
SRCREV_kernel_5.10 ?= "${SRCREV_kernel_vanilla_5.10}"
SRCREV_kernel_5.15 ?= "${SRCREV_kernel_vanilla_5.15}"

PV = "${BASE_PV}+git${SRCPV}"

## ignore where kernel is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "KERNEL_REFSPEC KERNEL_BASE_URI KERNEL_URI"

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = ""
