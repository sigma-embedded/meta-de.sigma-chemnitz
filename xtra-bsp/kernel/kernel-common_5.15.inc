## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.15"

require kernel-common.inc

# 5.15.147
SRCREV_kernel_vanilla_5.15 ?= "ddcaf49990615eb5659e8f06f5bab4bc3d65c4a5"
SRCREV_kernel_uapihdr_5.15 ?= "00f8c6dc8274d9b8e25102c7d46106dd8b9277ee"

SRCREV_kernel_5.15         ?= "${SRCREV_kernel_vanilla_5.15}"
