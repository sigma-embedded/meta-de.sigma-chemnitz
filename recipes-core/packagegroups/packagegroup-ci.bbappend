## override default implementation in -ci layer
PV = "5.0"

_ARCHPKGS = "\
"

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
    persistent-v4l \
"

DEPENDS += "\
    qemu-native \
    qemu-system-native \
    unfs3-native \
"
