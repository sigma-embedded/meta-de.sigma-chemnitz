## Add a '.note.package' section with information about the package to
## the built binaries.

ELF_PACKAGEDATA_FILE = "${WORKDIR}/elf-packagedata-ld"
ELF_PACKAGEDATA_LDLAGS = " -Wl,@${ELF_PACKAGEDATA_FILE}"

LDFLAGS[vardepsexclude] = "ELF_PACKAGEDATA_LDLAGS"
LDFLAGS .= "${ELF_PACKAGEDATA_LDLAGS}"

PACKAGEDATA_SRCREV ??= "${SRCREV}"

do_elf_packagedata_prepare[vardepsexclude] = "DISTRO_VERSION"
python do_elf_packagedata_prepare() {
    import json, shlex

    f = d.getVar('ELF_PACKAGEDATA_FILE')
    bb.utils.remove(f)

    data = {
        'os':        d.getVar('DISTRO_NAME'),
        'osVersion': d.getVar('DISTRO_VERSION'),
        'srcrev':    d.getVar('PACKAGEDATA_SRCREV'),
        'package': {
            'pn': d.getVar('PN'),
            'pv': d.getVar('PV'),
            'pr': d.getVar('PR'),
        },
        # for systemd compatibility... record would appear in
        # COREDUMP_PACKAGE_JSON nevertheless
        'name':      d.getVar('PN'),
        'version':   d.getVar('PACKAGEDATA_SRCREV') or d.getVar('PV'),
    }
    data = json.dumps(data, separators=(',', ':'))

    with open(f, "w") as f:
        f.write('--package-metadata=%s\n' % (shlex.quote(data)))
}
addtask elf_packagedata_prepare after do_patch before do_configure
