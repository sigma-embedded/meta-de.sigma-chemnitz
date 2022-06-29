LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=32fd56d355bd6a61017655d8da26b67c"

SRC_URI = "\
    git+https://github.com/ascent12/drm_info.git;branch=master \
    file://cross.patch \
    file://dupfmt.patch \
"

SRCREV = "5af85df6a7cd98a56cf2df8543bed503fc5c8591"

S = "${WORKDIR}/git"

DEPENDS += "json-c libdrm pciutils cmake-native"

EXTRA_OEMESON += "-Dsysroot='${RECIPE_SYSROOT}'"

inherit meson pkgconfig
