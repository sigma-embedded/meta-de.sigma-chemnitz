## Usage:
##
## ---------------
## inherit uboot-envsetup
##
## SRC_URI += "\
##     file://00-my-env.env \
## "
##
## do_uboot_envsetup:append() {
##     envsetup_file(d, "00-my-env.env")
##     envsetup_var(d, "bootcmd", "run my_boot")
## }
## ---------------
##
## Note:
## - envsetup_files() registers the files; they will be sorted lexically
## - envsetup_var() takes effect after processing the files and will
##   override their content
## - .env files are preprocessed by 'gcc -E'; e.g. comments are '/*
##   .. */' + '//' but not '#'

## private variables; used internally by scripts below
_UBOOT_ENVSETUP_FILES = ""
_UBOOT_ENVSETUP_CFG = "${WORKDIR}/envsetup/u-boot-env_generated.env"
_UBOOT_ENVSETUP_VARFILE = "${WORKDIR}/vars.env"

## u-boot requires both variables; ENV_FILE_CFG is the variable
## which is finally used but only when CONFIG_ENV_SOURCE_FILE is
## set.  CONFIG_ENV_SOURCE_FILE itself is a relative file somewhere
## in the board dir
_UBOOT_ENVSETUP_OEMAKE = "\
    CONFIG_ENV_SOURCE_FILE='${_UBOOT_ENVSETUP_CFG}' \
    ENV_FILE_CFG='${_UBOOT_ENVSETUP_CFG}' \
"

EXTRA_OEMAKE += "${_UBOOT_ENVSETUP_OEMAKE}"

do_uboot_envsetup[dirs] = "${WORKDIR}/envsetup"
do_uboot_envsetup[cleandirs] = "${WORKDIR}/envsetup"
python do_uboot_envsetup() {
    bb.note("gathering up u-boot environment")
    var_file = d.getVar('_UBOOT_ENVSETUP_VARFILE')

    oe.path.remove(var_file)
    open(var_file, mode='w')
}
addtask do_uboot_envsetup after do_patch before do_configure

python do_uboot_envsetup_generate_env() {
    bb.note("setting up u-boot environment file")

    setup_files = sorted(d.getVar('_UBOOT_ENVSETUP_FILES').split(), key = lambda f: os.path.basename(f))
    setup_files.append(d.getVar('_UBOOT_ENVSETUP_VARFILE'))

    with open(d.getVar('_UBOOT_ENVSETUP_CFG'), mode = "w") as outf:
        for infile in setup_files:
            with open(infile) as inf:
                outf.write(inf.read())

    bb.note("generated u-boot environment file")
}
do_uboot_envsetup[postfuncs] = "do_uboot_envsetup_generate_env"

def envsetup_file(d, fname):
    fname = os.path.join(d.getVar('WORKDIR', False), fname)
    d.appendVar("_UBOOT_ENVSETUP_FILES", ' ' + fname)

def envsetup_var(d, name, value):
    with open(d.getVar('_UBOOT_ENVSETUP_VARFILE'), mode = "a") as f:
        f.write('%s=%s\n' % (name, value))
