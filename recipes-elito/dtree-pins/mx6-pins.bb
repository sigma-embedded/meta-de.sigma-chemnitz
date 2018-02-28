# --*- python -*--
__SKIPPED := "${@bb.utils.contains('DISTRO_FEATURES', 'fsl-iomux', '', '1', d)}"

DESCRIPTION  = "${MACHINE} pin setup"
LICENSE      = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

def get_pin_funcs(soc):
    return { 'mx6q'     : 'imx6q-pinfunc.h',
             'mx6dl'    : 'imx6dl-pinfunc.h',
             'mx6s'     : 'imx6dl-pinfunc.h',
             'mx6sl'    : 'imx6sl-pinfunc.h' }[soc]

def get_makecmd(d):
    vars = ["SOC_DTREE_PINS_${MACHINE}=%s" %
            get_pin_funcs(d.getVar('MACHINE_SOC', True) or "mx6q")]

    targets = ['${MACHINE}']

    console = (d.getVar('SERIAL_CONSOLE', True) or "").split()
    uart = None
    if len(console) >= 2:
        uart = { "ttymxc0" : "uart1",
                 "ttymxc1" : "uart2",
                 "ttymxc2" : "uart3",
                 "ttymxc3" : "uart4" }.get(console[1])

    if uart:
        vars.append('UART=%s' % uart)

    return ' '.join(vars) + ' VARIANTS="' + ' '.join(targets) + '"'

DEPENDS += "fsliomux-conv-native virtual/kernel"

SRC_URI = "\
  file://Makefile \
  file://${MACHINE}-iomux.xml \
"

INHIBIT_DEFAULT_DEPS = "1"

EXTRA_OEMAKE[vardeps] += "SERIAL_CONSOLE"
EXTRA_OEMAKE = "\
  -f ${WORKDIR}/Makefile \
  MACHINE=${MACHINE} \
  VPATH=${WORKDIR}:${STAGING_MACHINCDIR}:${STAGING_KERNEL_DIR}/arch/${TARGET_ARCH}/boot/dts \
  prefix=${prefix} datadir=${datadir} \
  pkgdatadir=${MACHDATADIR} \
  pkgincludedir=${MACHINCDIR} \
  ${@get_makecmd(d)} \
"

COMPATIBLE_MACHINE = "mx6"

inherit elito-machdata elito-dtree-base

do_compile() {
    oe_runmake -e
}

do_install() {
    oe_runmake -e install DESTDIR=${D}
    install -D -p -m 0644 ${WORKDIR}/Makefile ${D}${MACHDATADIR}/mx6-pins.mk
}

FILES_${PN}-dev += "${MACHINCDIR}/* ${MACHDATADIR}/*.mk"
