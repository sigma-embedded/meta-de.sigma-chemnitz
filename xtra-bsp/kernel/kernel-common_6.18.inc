## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.18"

require kernel-common.inc

# 6.18.3
SRCREV_kernel_vanilla_6.18 ?= "a607c8f744340ad2c2486d46e96b66df47caffba"
SRCREV_kernel_uapihdr_6.18 ?= "a607c8f744340ad2c2486d46e96b66df47caffba"

SRCREV_kernel_6.18         ?= "${SRCREV_kernel_vanilla_6.18}"
