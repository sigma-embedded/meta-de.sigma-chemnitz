## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.15"

require kernel-common.inc

# 5.15.197
SRCREV_kernel_vanilla_5.15 ?= "68efe5a6c16a05391e3d96025b41e9bf573f968c"
SRCREV_kernel_uapihdr_5.15 ?= "a36130f7921c960562bf6b862651e7bcbd5a9dc0"

SRCREV_kernel_5.15         ?= "${SRCREV_kernel_vanilla_5.15}"
