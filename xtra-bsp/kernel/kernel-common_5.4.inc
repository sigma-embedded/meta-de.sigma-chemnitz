## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
BASE_PV = "5.4"

require kernel-common.inc

# 5.4.267
SRCREV_kernel_vanilla_5.4 ?= "9153fc9664959aa6bb35915b2bbd8fbc4c762962"
SRCREV_kernel_uapihdr_5.4 ?= "84ca356ec859478a2524a1885fae4bf7de4003b1"

SRCREV_kernel_5.4         ?= "${SRCREV_kernel_vanilla_5.4}"
