# BAREBOX_BASE_URI ?= "${@schilcher_component_uri(d, 'barebox')}"
# BAREBOX_REFSPEC  ?= ";branch=${BASE_PV}/schilcher"
# BAREBOX_REVISION ?= "0b666f81da14bf46cada222856762f7fd6641c26"
# inherit schilcher-component

INCPATH := "${LAYERDIR_de.sigma-chemnitz.core}/xtra-bsp/barebox"

require ${INCPATH}/barebox.inc
require ${INCPATH}/barebox-tools.inc
require ${INCPATH}/barebox-common_2024.05.inc
