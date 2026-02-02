## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.15"

require kernel-common.inc

# 5.15.198
SRCREV_kernel_vanilla_5.15 ?= "9eec9a14ee10820a0c00dd3e02ac1e0ab27ad142"
SRCREV_kernel_uapihdr_5.15 ?= "9eec9a14ee10820a0c00dd3e02ac1e0ab27ad142"

SRCREV_kernel_5.15         ?= "${SRCREV_kernel_vanilla_5.15}"
