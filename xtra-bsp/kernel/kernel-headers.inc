## --*- bitbake -*--
require recipes-kernel/linux-libc-headers/linux-libc-headers.inc

SRC_URI = "${KERNEL_URI}"
SRCREV = "${SRCREV_kernel_uapihdr_${BASE_PV}}"
