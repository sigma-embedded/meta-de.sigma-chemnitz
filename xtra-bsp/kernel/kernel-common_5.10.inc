## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "5.10"

require kernel-common.inc

# 5.10.215
SRCREV_kernel_vanilla_5.10 ?= "e2e4e7b4ae79e996789efaa42fdedddf8e3abad8"
SRCREV_kernel_uapihdr_5.10 ?= "95bd7e317d6c454fb12f4002fcc1a0655c3b4d8a"

SRCREV_kernel_5.10         ?= "${SRCREV_kernel_vanilla_5.10}"
