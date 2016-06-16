ELITO_COPY_TOPDIRS ?= ""
ELITO_COPY_TOPDIRS[type] = 'list'
ELITO_COPY_TOPDIRS[doc] = 'List of topdirectories which shall be copyied; when not absolute, paths are relative to ${THISDIR}'

ELITO_COPY_DEST ?= '/'
ELITO_COPY_MODE ?= 'a+rX,go-w'

ELITO_COPY_IGNORE_PATTERN = '*.bak .#* .git .emptydir'
ELITO_COPY_IGNORE_PATTERN[type] = 'list'
ELITO_COPY_IGNORE_PATTERN[doc] = 'shell pattern of files which shall be ignored'

ELITO_COPY_TARBALL = "elito-copytree-content.tar"
ELITO_COPY_TARFLAGS ?= "--no-recursion --no-wildcards"

DEPENDS += "tar-native"

def __elito_copy_get_content(d, content):
    if content == None:
        content = d.getVarFlag('ELITO_COPY_TOPDIRS', '__content', False)

    if content == None:
        import elito.copytree
        content = elito.copytree.prepare(d)
        d.setVarFlag('ELITO_COPY_TOPDIRS', '__content', content)

    return content

def elito_copytree_get_hash(d, content = None):
    return __elito_copy_get_content(d, content)[0]

def elito_copytree_get_tar_args(d, content = None):
    return (' '.join(map(lambda x: x.tar_opt(True),
                         __elito_copy_get_content(d, content)[1])))

python() {
    content = __elito_copy_get_content(d, None)
    d.setVar('ELITO_COPY_TOPDIRS_HASH', elito_copytree_get_hash(d, content))
    d.setVar('ELITO_COPY_TAR_ARGS', elito_copytree_get_tar_args(d, content))
}

elito_copytree_compile[vardeps] += "ELITO_COPY_TOPDIRS_HASH"
elito_copytree_compile() {
    tar cf ${ELITO_COPY_TARBALL} ${ELITO_COPY_TARFLAGS} \
        ${ELITO_COPY_TAR_ARGS} -T /dev/null
}

elito_copytree_install() {
    install -d "${D}${ELITO_COPY_DEST}"
    tar xf ${ELITO_COPY_TARBALL} -C "${D}${ELITO_COPY_DEST}"
}

do_compile() {
    elito_copytree_compile
}

do_install() {
    elito_copytree_install
}
