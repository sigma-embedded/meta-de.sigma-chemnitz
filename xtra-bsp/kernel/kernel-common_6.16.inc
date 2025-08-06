## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.16"

require kernel-common.inc

# 6.16.11
SRCREV_kernel_vanilla_6.16 ?= "038d61fd642278bab63ee8ef722c50d10ab01e8f"
SRCREV_kernel_uapihdr_6.16 ?= "038d61fd642278bab63ee8ef722c50d10ab01e8f"

SRCREV_kernel_6.16         ?= "${SRCREV_kernel_vanilla_6.16}"
