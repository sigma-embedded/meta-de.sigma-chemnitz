## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.10"

require kernel-common.inc

# 5.10.221
SRCREV_kernel_vanilla_5.10 ?= "6ab8b697d7d1ff0a127a7774489311d878dad04c"
SRCREV_kernel_uapihdr_5.10 ?= "d5f75f01994e399500264a07585935adab948ee5"

SRCREV_kernel_5.10         ?= "${SRCREV_kernel_vanilla_5.10}"
