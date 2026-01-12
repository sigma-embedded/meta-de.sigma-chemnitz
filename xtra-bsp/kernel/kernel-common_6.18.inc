## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.18"

require kernel-common.inc

# 6.18.4
SRCREV_kernel_vanilla_6.18 ?= "3aa9aac0e8b767a7c6fac33ae626a332c2ba1389"
SRCREV_kernel_uapihdr_6.18 ?= "20710399c9b5ef80e21d13fa0138b1370e358c8f"

SRCREV_kernel_6.18         ?= "${SRCREV_kernel_vanilla_6.18}"
