## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.15"

require kernel-common.inc

# 5.15.138
SRCREV_kernel_vanilla_5.15 ?= "80529b4968a8052f894d00021a576d8a2d89aa08"
SRCREV_kernel_uapihdr_5.15 ?= "e163ad6a8639bb28f5aee683f04929cb07dd5990"

SRCREV_kernel_5.15         ?= "${SRCREV_kernel_vanilla_5.15}"
