## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.1
SRCREV_kernel_vanilla_6.6 ?= "8afabe2118a9fccaa19a51ef7a1d18e941b712b0"
SRCREV_kernel_uapihdr_6.6 ?= "c17cda15cc86e65e9725641daddcd7a63cc9ad01"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
