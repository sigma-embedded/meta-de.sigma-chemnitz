## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
BASE_PV = "5.4"

require kernel-common.inc

# 5.4.279
SRCREV_kernel_vanilla_5.4 ?= "50967319488f7e9a0052f1c241894e12a31f01fc"
SRCREV_kernel_uapihdr_5.4 ?= "6302bdfeb45f9d20ef99aeaf982a1a04bb5a3bb6"

SRCREV_kernel_5.4         ?= "${SRCREV_kernel_vanilla_5.4}"
