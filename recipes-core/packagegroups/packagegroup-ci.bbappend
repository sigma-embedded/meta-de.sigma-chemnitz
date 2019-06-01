## override default implementation in -ci layer
PV = "5.0"

RRECOMMENDS_${PN} = "\
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
