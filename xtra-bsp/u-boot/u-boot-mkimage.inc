## --*- bitbake -*--
KERNEL_CC_append_class-native    = " ${BUILD_LDFLAGS}"
KERNEL_CC_append_class-nativesdk  = " ${BUILD_LDFLAGS}"

TOOLCHAIN_OPTIONS_class-native    = " -isystem${STAGING_INCDIR_NATIVE}"
TOOLCHAIN_OPTIONS_class-nativesdk = " -isystem${STAGING_INCDIR_NATIVE}"

HOST_CC_KERNEL_ARCH = "${HOST_CC_ARCH}"

DEPENDS += "openssl"


do_configure() {
	oe_runmake sandbox_defconfig
}

do_compile () {
	oe_runmake cross_tools NO_SDL=1
}

do_install () {
	install -D -p -m 0755 tools/mkimage ${D}${bindir}/uboot-mkimage
	ln -sf uboot-mkimage ${D}${bindir}/mkimage
}

BBCLASSEXTEND = "native nativesdk"
