## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.1"

require kernel-common.inc

# 6.1.161
SRCREV_kernel_vanilla_6.1 ?= "cd9b81672742d239a3f05fe545bf4212b56d0ac9"
SRCREV_kernel_uapihdr_6.1 ?= "cd9b81672742d239a3f05fe545bf4212b56d0ac9"

SRCREV_kernel_6.1         ?= "${SRCREV_kernel_vanilla_6.1}"
