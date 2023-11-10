## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
BASE_PV = "5.4"

require kernel-common.inc

# 5.4.260
SRCREV_kernel_vanilla_5.4 ?= "87e8e7a7aa1f96276252a90373de1d56add31918"
SRCREV_kernel_uapihdr_5.4 ?= "2ab1b7ad50466422ac8966f67a92452718865ac2"

SRCREV_kernel_5.4         ?= "${SRCREV_kernel_vanilla_5.4}"
