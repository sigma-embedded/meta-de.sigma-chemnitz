## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.1"

require kernel-common.inc

# 6.1.62
SRCREV_kernel_vanilla_6.1 ?= "fb2635ac69abac0060cc2be2873dc4f524f12e66"
SRCREV_kernel_uapihdr_6.1 ?= "039a050740fc0b6a6efb7e157cb2ec002393a4f6"

SRCREV_kernel_6.1         ?= "${SRCREV_kernel_vanilla_6.1}"
