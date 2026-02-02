## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.12"

require kernel-common.inc

# 6.12.68
SRCREV_kernel_vanilla_6.12 ?= "90ecf7d9daa2d0167e20b2e9f6f52e01f47b8147"
SRCREV_kernel_uapihdr_6.12 ?= "90ecf7d9daa2d0167e20b2e9f6f52e01f47b8147"

SRCREV_kernel_6.12         ?= "${SRCREV_kernel_vanilla_6.12}"
