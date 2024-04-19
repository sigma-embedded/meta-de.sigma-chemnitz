## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.28
SRCREV_kernel_vanilla_6.6 ?= "ba151416051a45ffca565f708584b9cd5c971481"
SRCREV_kernel_uapihdr_6.6 ?= "ed2f8b713a459e04cc4b29090ed61da2f5e748ab"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
