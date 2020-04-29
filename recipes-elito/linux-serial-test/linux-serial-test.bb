DESCRIPTION = "Serial test application"
HOMEPAGE = "https://github.com/cbrake/linux-serial-test"
SECTION = "utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSES/MIT;md5=544799d0b492f119fa04641d1b8868ed"
SRCREV = "1e00d17d36086b2f6c1c10af120af8520b43803a"

SRC_URI = "\
    git+https://github.com/cbrake/linux-serial-test.git;branch=master \
"

S = "${WORKDIR}/git/"

inherit cmake
