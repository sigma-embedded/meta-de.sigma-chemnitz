## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.10"

require kernel-common.inc

# 5.10.200
SRCREV_kernel_vanilla_5.10 ?= "3e55583405ac3f8651966dcd23590adb3db1d8c2"
SRCREV_kernel_uapihdr_5.10 ?= "e4c4e0e1b29ca5ca539ae3cea8145e0a8154420e"

SRCREV_kernel_5.10         ?= "${SRCREV_kernel_vanilla_5.10}"
