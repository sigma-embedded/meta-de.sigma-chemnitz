## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.17"

require kernel-common.inc

# 6.17.13
SRCREV_kernel_vanilla_6.17 ?= "6609c4d49ebe220a5c40d3105c3f0e68f569ba1a"
SRCREV_kernel_uapihdr_6.17 ?= "152b482a4b87e547d9bf46a49b268844253134d1"

SRCREV_kernel_6.17         ?= "${SRCREV_kernel_vanilla_6.17}"
