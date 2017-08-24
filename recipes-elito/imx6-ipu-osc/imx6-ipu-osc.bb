SUMMARY = "Displays IPU data pins"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

SRCREV = "5d5140e287f111f3cf63099707df8abc1707eb37"
SRC_URI = "git://github.com/sigma-embedded/elito-mx6-osc.git;protocol=https"

EXTRA_OEMAKE = "-f ${S}/Makefile VPATH=${S} -e"

COMPATIBLE_MACHINE = "mx6q|mx6dl|mx6d"

S = "${WORKDIR}/git"

inherit autotools
