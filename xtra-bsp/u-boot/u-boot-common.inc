## --*- bitbake -*--
HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"

LICENSE = "GPLv2+"

UBOOT_BASE_URI ?= "git+https://github.com/u-boot/u-boot.git"
UBOOT_REFSPEC  ?= ";branch=v${BASE_PV};nobranch=1"
UBOOT_URI      ?= "${UBOOT_BASE_URI}${UBOOT_REFSPEC}"

## ignore where u-boot is coming from; git rev is unique enough...
SRC_URI[vardepsexclude] += "UBOOT_REFSPEC UBOOT_BASE_URI UBOOT_URI"
