## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.12"

require kernel-common.inc

# 6.12.11
SRCREV_kernel_vanilla_6.12 ?= "62b2447ec6cf3f8ce4b768cacd7b787a04f54a14"
SRCREV_kernel_uapihdr_6.12 ?= "a39ff5bf2357c737f558b28f4f579261bdbc2966"

SRCREV_kernel_6.12         ?= "${SRCREV_kernel_vanilla_6.12}"
