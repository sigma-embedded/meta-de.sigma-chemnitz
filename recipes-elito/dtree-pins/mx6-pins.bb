# --*- python -*--
DESCRIPTION  = "${MACHINE} pin setup"
LICENSE      = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

def get_iomux_files(d):
    return ' '.join(map(lambda x: 'file://%s-iomux.xml' % x.split(':')[0],
                        oe.data.typed_value('MACHINE_VARIANTS', d)))

def get_pin_funcs(soc):
    return { 'mx6q'     : 'imx6q-pinfunc.h',
             'mx6dl'    : 'imx6dl-pinfunc.h',
             'mx6s'     : 'imx6dl-pinfunc.h',
             'mx6sl'    : 'imx6sl-pinfunc.h' }[soc]

def get_makecmd(d):
    variants = oe.data.typed_value('MACHINE_VARIANTS', d)
    targets = []
    vars = []
    for v in variants:
        (board, soc, mem) = v.split(':')
        targets.append(board)
        vars.append('SOC_DTREE_PINS_%s=%s' % (board, get_pin_funcs(soc)))

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

SRC_URI[vardeps] += "MACHINE_VARIANTS"
SRC_URI = "\
  file://Makefile \
  ${@get_iomux_files(d)} \
"

INHIBIT_DEFAULT_DEPS = "1"

EXTRA_OEMAKE[vardeps] += "MACHINE_VARIANTS SERIAL_CONSOLE"
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
    oe_runmake
}

do_install() {
    oe_runmake install DESTDIR=${D}
    install -D -p -m 0644 ${WORKDIR}/Makefile ${D}${MACHDATADIR}/mx6-pins.mk
}

FILES_${PN}-dev += "${MACHINCDIR}/* ${MACHDATADIR}/*.mk"
