## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.122
SRCREV_kernel_vanilla_6.6 ?= "2cf6f68313dcc3c404f49fdee41bbf3c694ad75d"
SRCREV_kernel_uapihdr_6.6 ?= "2cf6f68313dcc3c404f49fdee41bbf3c694ad75d"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
