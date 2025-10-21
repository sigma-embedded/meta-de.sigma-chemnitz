BAREBOX_REVISION ??= "${SRCREV_barebox_${BASE_PV}}"

BBCLASSEXTEND = "native nativesdk"

EXTRA_OEMAKE += "ARCH=sandbox"

TOOL_TARGETS[bareboxcrc32] = "BAREBOXCRC32"
TOOL_TARGETS[bareboxenv] = "BAREBOXENV"
TOOL_TARGETS[kwboot] = "MVEBU_KWBOOT"
TOOL_TARGETS[imx-usb-loader] = "ARCH_IMX_USBLOADER"
TOOL_DIR[imx-usb-loader] = "imx"
TOOL_TARGETS[omap3-usb-loader] = "OMAP3_USB_LOADER"
TOOL_TARGETS[omap4_usbboot] = "OMAP4_USBBOOT"
TOOL_TARGETS[rk-usb-loader] = "RK_USB_LOADER"

TOOL_TARGETS = "bareboxcrc32 bareboxenv kwboot imx-usb-loader omap3-usb-loader omap4_usbboot rk-usb-loader"

DEPENDS += "libusb1 openssl"

EXTRA_CFG = ""
EXTRA_CFG:append:x86-64 = " CONFIG_64BIT=y"
EXTRA_CFG:append:aarch64 = " CONFIG_64BIT=y"

do_configure[vardeps] += "TOOL_TARGETS"
do_configure() {
        ##
	oe_runmake allnoconfig

	echo '${@create_config(d)}' >> .config
	oe_runmake olddefconfig
}

do_compile() {
	## set 'pbl-y=' to override arch/x86/um/Makefile actions; we
	## want to build the tools only and build of arch files will
	## fail
	oe_runmake pbl-y= scripts/
}

do_install[vardeps] += "TOOL_TARGETS TOOL_DIR"
do_install() {
	${@create_install(d)}
}

def create_config(d):
    cfg = []
    for t in (d.getVar('TOOL_TARGETS') or '').split():
        try:
            cfg.extend(['CONFIG_%s_TARGET=y' % v for v in d.getVarFlag('TOOL_TARGETS', t).split()])
        except Exception as e:
            bb.fatal("failed to create config for %s TOOL_TARGET: %s" % (t, e))
            raise e
    cfg.extend(d.getVar('EXTRA_CFG').split())
    cfg.append('')
    return '\n'.join(cfg)

def create_install(d, base_dir='scripts/', dstdir='${D}${bindir}/'):
    import shlex

    cmd = ['\n']
    for t in (d.getVar('TOOL_TARGETS') or '').split():
        src = base_dir
        sub = d.getVarFlag('TOOL_DIR', t)
        if sub:
            src = os.path.join(src, sub)
        cmd.append('\tinstall -D -p -m 0755 %s %s\n' %
                   (shlex.quote('%s/%s-target' % (src, t)), shlex.quote('%s/%s' % (dstdir, t))))
    cmd.append('\n')
    return ''.join(cmd)
