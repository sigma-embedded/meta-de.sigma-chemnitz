LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"
SRC_URI = "\
    git+https://github.com/pengutronix/memtool.git;branch=master \
    file://0001-add-option-for-raw-output.patch \
"

PR = "2018.03.0"
SRCREV = "97a50b57930743aaa3e2ba3e1a41e9d93ce07f43"

inherit autotools

S = "${WORKDIR}/git"

EXTRA_OECONF = "\
    --enable-mdio \
"
