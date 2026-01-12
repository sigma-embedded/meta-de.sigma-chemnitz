## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.10"

require kernel-common.inc

# 5.10.247
SRCREV_kernel_vanilla_5.10 ?= "f964b940099f9982d723d4c77988d4b0dda9c165"
SRCREV_kernel_uapihdr_5.10 ?= "c8879afa24169e504f78c9ca43a4d0d7397049eb"

SRCREV_kernel_5.10         ?= "${SRCREV_kernel_vanilla_5.10}"
