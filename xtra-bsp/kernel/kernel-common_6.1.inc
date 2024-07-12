## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.1"

require kernel-common.inc

# 6.1.98
SRCREV_kernel_vanilla_6.1 ?= "266ee8e06d5baa186a0b5b8727eb99ae2d00dc9c"
SRCREV_kernel_uapihdr_6.1 ?= "e1b88ac1fe65a5e9f7ecbf7ca72bd48f317fa2fb"

SRCREV_kernel_6.1         ?= "${SRCREV_kernel_vanilla_6.1}"
