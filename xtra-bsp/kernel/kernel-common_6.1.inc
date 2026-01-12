## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.1"

require kernel-common.inc

# 6.1.159
SRCREV_kernel_vanilla_6.1 ?= "50cbba13faa294918f0e1a9cb2b0aba19f4e6fba"
SRCREV_kernel_uapihdr_6.1 ?= "42077fef30eb13b25bc7b3346aa7db2a5bc3fe69"

SRCREV_kernel_6.1         ?= "${SRCREV_kernel_vanilla_6.1}"
