## override default implementation in -ci layer
PV = "5.0"

_ARCHPKGS = "\
"

RRECOMMENDS:${PN} = "\
    ${_ARCHPKGS} \
    barebox-tools \
    e2fsprogs \
    elito-decode-definitions \
    elito-fbtest \
    gengetopt \
    systemd \
    unfs3 \
    fbcat \
    persistent-v4l \
    bayer2rgb-neon \
    gstreamer1.0-plugin-bayer2rgb-neon \
    gstreamer1.0-plugins-good \
    strace \
    drm-info \
\
    native-ci \
"
