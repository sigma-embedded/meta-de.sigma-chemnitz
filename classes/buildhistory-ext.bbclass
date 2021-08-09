inherit buildhistory

buildhistory_get_imageinfo:append() {
	cat << "EOF" > ${BUILDHISTORY_DIR_IMAGE}/image-features.txt
DISTRO_FEATURES = ${@' '.join(sorted(set(d.getVar('DISTRO_FEATURES', True).split())))}
MACHINE_FEATURES = ${@' '.join(sorted(set(d.getVar('MACHINE_FEATURES', True).split())))}
EOF
}

buildhistory_emit_pkghistory:append() {
    buildhistory_ext_emit_features(d)
}

def buildhistory_ext_emit_features(d):
    bb.debug(2, "Writing recipe feature history")

    pkghistdir = d.getVar('BUILDHISTORY_DIR_PACKAGE')

    infofile = os.path.join(pkghistdir, "latest")
    pcfg     = d.getVar('PACKAGECONFIG', True)
    with open(infofile, "a") as f:
        if pcfg:
            f.write(u"PACKAGECONFIG = %s\n" % ' '.join(sorted(set(pcfg.split()))))
