SUMMARY = "imx6 rescue system loader"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

PV   = "0.1.0+gitr${SRCPV}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

## to be set in .bbappend
COMPATIBLE_MACHINE = "(-)"

MX6_LOAD_BRANCH ??= "master"
MX6_LOAD_GIT_REPO ??= "${PROJECT_BASE_REPO}/elito-mx6-load.git;branch=${MX6_LOAD_BRANCH}"

SRC_URI = "\
    ${MX6_LOAD_GIT_REPO} \
"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

DEPENDS += "elito-devicetree virtual/bootloader dtc-native"

inherit elito-machdata deploy

MX6_LOAD_VARIANTS ?= ""
MX6_LOAD_SOCTYPES ?= ""

KERNEL_IMAGE ?= "${DEPLOY_DIR_IMAGE}/zImage"
DCDPATH ?= "${STAGING_MACHDATADIR}"
KERNEL_MACHTYPE ?= "0xffffffff"

EXTRA_OEMAKE = "\
    -f ${S}/Makefile \
    KERNEL_IMAGE='${KERNEL_IMAGE}' \
    DCDPATH='${DCDPATH}' \
    MACHINE='${MACHINE}' \
    MACHTYPE='${KERNEL_MACHTYPE}' \
    VARIANTS='${MX6_LOAD_VARIANTS}' \
    SOC_TYPES='${MX6_LOAD_SOCTYPES}' \
    PARAM_MEM_1gib=1gib \
    PARAM_MEM_2gib=2gib \
"

do_compile[depends] += "virtual/rescue-kernel:do_deploy"
do_compile() {
	oe_runmake all
}

do_deploy() {
	for i in ${MX6_LOAD_VARIANTS}; do
		install -D -p -m 0644 load-linux-$i.bin ${DEPLOYDIR}/rescue-${PKGV}-${PKGR}-${MACHINE}-$i.imx
		ln -sf rescue-${PKGV}-${PKGR}-${MACHINE}-$i.imx ${DEPLOYDIR}/rescue-$i.imx
	done
}
addtask do_deploy before do_build after do_compile
