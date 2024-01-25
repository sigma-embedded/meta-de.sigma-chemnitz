## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.13
SRCREV_kernel_vanilla_6.6 ?= "62b19b564504d027296502e0e30baf5fe0ef080a"
SRCREV_kernel_uapihdr_6.6 ?= "9f36c1c5132f3a03f420e88924b8829b508c59b8"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
