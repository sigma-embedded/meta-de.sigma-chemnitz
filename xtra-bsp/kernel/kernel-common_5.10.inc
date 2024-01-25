## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.10"

require kernel-common.inc

# 5.10.208
SRCREV_kernel_vanilla_5.10 ?= "3fee45ee557aef5bfcd2b10e368c30bf3aef497a"
SRCREV_kernel_uapihdr_5.10 ?= "8bd3d61624d503ebe8b8469021a03bef359f89de"

SRCREV_kernel_5.10         ?= "${SRCREV_kernel_vanilla_5.10}"
