## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.119
SRCREV_kernel_vanilla_6.6 ?= "5fa4793a2d2d70ad08b85387b41020f1fcc2d19e"
SRCREV_kernel_uapihdr_6.6 ?= "650150cc9a3e0aacf0860a7c3f97fc103644ea7e"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
