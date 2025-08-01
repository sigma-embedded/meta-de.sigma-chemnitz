LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=32fd56d355bd6a61017655d8da26b67c"

SRC_URI = "\
    git+https://gitlab.freedesktop.org/emersion/drm_info.git;branch=master \
    file://dupfmt.patch \
"

SRCREV = "b89557d57edd9bb43894e5917c11ac92fdafcc50"

PV = "2.6.0"

DEPENDS += "json-c libdrm pciutils cmake-native"

inherit meson pkgconfig
