## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.39
SRCREV_kernel_vanilla_6.6 ?= "2ced7518a03d002284999ed8336ffac462a358ec"
SRCREV_kernel_uapihdr_6.6 ?= "9258d795978f398ecf2d222a8388cff81d37d34d"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
