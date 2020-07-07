DESCRIPTION = "Serial test application"
HOMEPAGE = "https://github.com/cbrake/linux-serial-test"
SECTION = "utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSES/MIT;md5=544799d0b492f119fa04641d1b8868ed"
SRCREV = "0685fc53870f52d38af82bdcddaeb6dc0182fb72"

SRC_URI = "\
    git+https://github.com/cbrake/linux-serial-test.git;branch=master \
"

S = "${WORKDIR}/git/"

inherit cmake
