## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.12"

require kernel-common.inc

# 6.12.64
SRCREV_kernel_vanilla_6.12 ?= "1a4a7249e794de9e022baabe6387d9c0f831b0be"
SRCREV_kernel_uapihdr_6.12 ?= "984dc07404e2de65dbdaed435791af908d9cf5b7"

SRCREV_kernel_6.12         ?= "${SRCREV_kernel_vanilla_6.12}"
