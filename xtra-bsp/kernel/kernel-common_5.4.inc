## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
BASE_PV = "5.4"

require kernel-common.inc

# 5.4.274
SRCREV_kernel_vanilla_5.4 ?= "0dbd436fb9908fbb442cb4c6e28044a891360229"
SRCREV_kernel_uapihdr_5.4 ?= "71de605098761f0a9d4538363689d1c8480b7549"

SRCREV_kernel_5.4         ?= "${SRCREV_kernel_vanilla_5.4}"
