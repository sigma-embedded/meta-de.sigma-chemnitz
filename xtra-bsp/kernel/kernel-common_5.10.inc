## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.10"

require kernel-common.inc

# 5.10.248
SRCREV_kernel_vanilla_5.10 ?= "9260a632f76e4743a6209992c5c22919e749ffd3"
SRCREV_kernel_uapihdr_5.10 ?= "9260a632f76e4743a6209992c5c22919e749ffd3"

SRCREV_kernel_5.10         ?= "${SRCREV_kernel_vanilla_5.10}"
