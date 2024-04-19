## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.15"

require kernel-common.inc

# 5.15.156
SRCREV_kernel_vanilla_5.15 ?= "c52b9710c83d3b8ab63bb217cc7c8b61e13f12cd"
SRCREV_kernel_uapihdr_5.15 ?= "18c51d97a242fcc1b45e344d18467de4ade7e438"

SRCREV_kernel_5.15         ?= "${SRCREV_kernel_vanilla_5.15}"
