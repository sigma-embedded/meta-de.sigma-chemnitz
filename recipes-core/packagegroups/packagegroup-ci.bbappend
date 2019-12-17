## override default implementation in -ci layer
PV = "5.0"

_ARCHPKGS = "\
    valgrind \
"

_ARCHPKGS_remove_armv4 = "valgrind"
_ARCHPKGS_remove_armv5 = "valgrind"
_ARCHPKGS_remove_armv6 = "valgrind"
_ARCHPKGS_remove_linux-gnux32 = "valgrind"
_ARCHPKGS_remove_linux-gnux32 = "valgrind"
_ARCHPKGS_remove_linux-muslx32 = "valgrind"
_ARCHPKGS_remove_mipsarchr6 = "valgrind"

RRECOMMENDS_${PN} = "\
    ${_ARCHPKGS} \
    e2fsprogs \
    elito-decode-definitions \
    elito-fbtest \
    elito-image-stream \
    gengetopt \
    libccgi \
    systemd \
    unfs3 \
    fbcat \
    persistent-v4l \
"

DEPENDS += "\
    qemu-native \
    unfs3-native \
"
