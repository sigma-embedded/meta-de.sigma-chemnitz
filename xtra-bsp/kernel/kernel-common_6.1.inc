## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.1"

require kernel-common.inc

# 6.1.87
SRCREV_kernel_vanilla_6.1 ?= "6741e066ec7633450d3186946035c1f80c4226b8"
SRCREV_kernel_uapihdr_6.1 ?= "70310e55b52922afa4d9dfa4d60ba35602828455"

SRCREV_kernel_6.1         ?= "${SRCREV_kernel_vanilla_6.1}"
