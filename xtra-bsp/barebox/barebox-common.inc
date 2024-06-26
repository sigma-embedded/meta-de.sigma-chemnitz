# --*- bitbake -*--
DESCRIPTION = "The barebox (formerly U-Boot v2) bootloader"

BAREBOX_BASE_URI ??= "git+https://git.pengutronix.de/git/barebox.git"
BAREBOX_REFSPEC  ??= ";branch=v${BASE_PV}.0;nobranch=1"
BAREBOX_URI      ??= "${BAREBOX_BASE_URI}${BAREBOX_REFSPEC}"

SRCREV_barebox_2016.02 = "2608e27f6e2d24a6ff23e45d177a312007496afa"
SRCREV_barebox_2016.11 = "d39a63184c7524f7329a8316228554c123903b29"
SRCREV_barebox_2017.12 = "d67aed662306dff4b2ab3064ebf81ef86cae1172"
SRCREV_barebox_2019.03 = "c7a3ae7ec058e72adc0dae3ab41e47e475295d41"
SRCREV_barebox_2019.11 = "5f16eba7068a7f04e6a7f8734cbff909440a1ef0"
SRCREV_barebox_2020.06 = "4e5372bb1f15146bcf9d1df89bf45fb78e39f30c"
SRCREV_barebox_2021.01 = "9f8e6f6a38a8f9351ea110eae9ff0dc62fde5220"
SRCREV_barebox_2021.07 = "4d8f00486177ea013a1f767df7b3c20c33169c7c"
SRCREV_barebox_2021.10 = "dc9f4c29bece2cc66946f56cef9c5868afa92838"
SRCREV_barebox_2021.12 = "b21ac7bbd98f9bf21f9753a9974e22f368b6ec1f"
SRCREV_barebox_2022.02 = "179eeaeb5ed73d2b49b1494b5e058009b5fb9a0d"
SRCREV_barebox_2022.06 = "512d036587a38c57a30cc63ce48c19c895b9d729"
SRCREV_barebox_2022.09 = "2e408b292877f72b0483209069dbccd200f56d31"
SRCREV_barebox_2022.10 = "e7e8440c308677e2d11f508a81bffbe56223577e"
SRCREV_barebox_2022.11 = "f1b22deeb6ed8bfef865990b8404874e66f9b4d7"
SRCREV_barebox_2023.06 = "7033a67d0c7e0f39edbf51a1e0b182b00c6b80ec"
SRCREV_barebox_2023.07 = "0186c17838e655dbf6a3bcd01fa74821d5e67ae6"

PV = "${BASE_PV}+git${SRCPV}"

##############

inherit kernel-arch
inherit pkgconfig

## we want only to "unexport" them; but this is not supported by
## bitbake.  Unset variables and redefine them later.
unset CFLAGS
unset LDFLAGS

CFLAGS = "${TARGET_CFLAGS}"
LDFLAGS = "${TARGET_LDFLAGS}"

## do not use single quotes!
X_CROSS_PKG_CONFIG = "\
    env \
    PKG_CONFIG_SYSROOT_DIR=${STAGING_DIR_TARGET} \
    PKG_CONFIG_DIR=${STAGING_DIR_TARGET}${libdir_native}/pkgconfig \
    PKG_CONFIG_PATH=${PKG_CONFIG_DIR}:${STAGING_DATADIR_TARGET}/pkgconfig \
    PKG_CONFIG_LIBDIR=${PKG_CONFIG_DIR} \
    pkg-config \
"

## do not use single quotes!
X_PKG_CONFIG = "\
    env \
    PKG_CONFIG_SYSROOT_DIR=${STAGING_DIR_NATIVE} \
    PKG_CONFIG_DIR=${STAGING_DIR_NATIVE}${libdir_native}/pkgconfig \
    PKG_CONFIG_PATH=${PKG_CONFIG_DIR}:${STAGING_DATADIR_NATIVE}/pkgconfig \
    PKG_CONFIG_LIBDIR=${PKG_CONFIG_DIR} \
    pkg-config \
"

EXTRA_OEMAKE += "\
    -C ${S} \
    KBUILD_OUTPUT=${B} V=1 \
    CROSS_COMPILE='${TARGET_PREFIX}' \
    CC='${KERNEL_CC}' \
    LD='${KERNEL_LD}' \
    USERCFLAGS='${TARGET_CC_ARCH}${TOOLCHAIN_OPTIONS} ${TARGET_CFLAGS}' \
    USERLDFLAGS='${TARGET_CC_ARCH}${TOOLCHAIN_OPTIONS} ${TARGET_LDFLAGS}' \
    HOSTLDFLAGS='${BUILD_LDFLAGS}' \
    HOSTCC='${BUILD_CC}' \
    HOSTCFLAGS='${BUILD_CFLAGS}' \
    HOSTCXX='${BUILD_CXX}' \
    HOSTCXXFLAGS='${BUILD_CXXFLAGS}' \
    HOSTCPP='${BUILD_CPP} ${BUILD_CPPFLAGS}' \
    CROSS_PKG_CONFIG='${X_CROSS_PKG_CONFIG}' \
    PKG_CONFIG='${X_PKG_CONFIG}' \
"

BUILDVARS_EXPORT += "\
    ARCH \
    TARGET \
    KERNEL_AR \
    KERNEL_CC \
    KERNEL_LD \
    X_PKG_CONFIG \
    X_CROSS_PKG_CONFIG \
"
