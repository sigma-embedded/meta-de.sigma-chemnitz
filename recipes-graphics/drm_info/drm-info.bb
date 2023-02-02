LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=32fd56d355bd6a61017655d8da26b67c"

SRC_URI = "\
    git+https://gitlab.freedesktop.org/emersion/drm_info.git;branch=master \
    file://cross.patch \
    file://dupfmt.patch \
"

SRCREV = "e318e93f9096d373d362395dacd7af2c03f7148e"

S = "${WORKDIR}/git"

DEPENDS += "json-c libdrm pciutils cmake-native"

EXTRA_OEMESON += "-Dsysroot='${RECIPE_SYSROOT}'"

inherit meson pkgconfig
