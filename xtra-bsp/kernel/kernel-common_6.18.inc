## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.18"

require kernel-common.inc

# 6.18.8
SRCREV_kernel_vanilla_6.18 ?= "d905362ff5b86f6b619953ada8e0af84158db2e9"
SRCREV_kernel_uapihdr_6.18 ?= "d905362ff5b86f6b619953ada8e0af84158db2e9"

SRCREV_kernel_6.18         ?= "${SRCREV_kernel_vanilla_6.18}"
