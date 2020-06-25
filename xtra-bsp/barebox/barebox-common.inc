# --*- bitbake -*--
DESCRIPTION = "The barebox (formerly U-Boot v2) bootloader"
PROVIDES = "virtual/bootloader"

BAREBOX_BASE_URI ??= "git+https://git.pengutronix.de/git/barebox.git"
BAREBOX_REFSPEC  ??= ";branch=v${BASE_PV}.0;nobranch=1"
BAREBOX_URI      ??= "${BAREBOX_BASE_URI}${BAREBOX_REFSPEC}"

SRCREV_barebox_2016.02 = "2608e27f6e2d24a6ff23e45d177a312007496afa"
SRCREV_barebox_2016.11 = "d39a63184c7524f7329a8316228554c123903b29"
SRCREV_barebox_2017.12 = "d67aed662306dff4b2ab3064ebf81ef86cae1172"
SRCREV_barebox_2019.03 = "c7a3ae7ec058e72adc0dae3ab41e47e475295d41"
SRCREV_barebox_2019.11 = "5f16eba7068a7f04e6a7f8734cbff909440a1ef0"
SRCREV_barebox_2020.06 = "4e5372bb1f15146bcf9d1df89bf45fb78e39f30c"

PV = "${BASE_PV}+git${SRCPV}"
