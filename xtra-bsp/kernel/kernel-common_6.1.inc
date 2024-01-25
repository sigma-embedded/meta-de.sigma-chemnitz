## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.1"

require kernel-common.inc

# 6.1.74
SRCREV_kernel_vanilla_6.1 ?= "8fd7f44624538675abadc73f5a44e95016964d22"
SRCREV_kernel_uapihdr_6.1 ?= "0bfbfd9423f3c31db2d448109578e3df43eb5238"

SRCREV_kernel_6.1         ?= "${SRCREV_kernel_vanilla_6.1}"
