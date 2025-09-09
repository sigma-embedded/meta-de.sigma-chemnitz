## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.17"

require kernel-common.inc

# 6.17.9
SRCREV_kernel_vanilla_6.17 ?= "1bfd0faa78d09eb41b81b002e0292db0f3e75de0"
SRCREV_kernel_uapihdr_6.17 ?= "1bfd0faa78d09eb41b81b002e0292db0f3e75de0"

SRCREV_kernel_6.17         ?= "${SRCREV_kernel_vanilla_6.17}"
