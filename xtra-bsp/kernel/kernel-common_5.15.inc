## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.15"

require kernel-common.inc

# 5.15.162
SRCREV_kernel_vanilla_5.15 ?= "f45bea23c39cbd0d9b89d6b43563b02aa2dfe5de"
SRCREV_kernel_uapihdr_5.15 ?= "16c0403b7dec2b255b5aaf2b6b203aa3b96a1775"

SRCREV_kernel_5.15         ?= "${SRCREV_kernel_vanilla_5.15}"
