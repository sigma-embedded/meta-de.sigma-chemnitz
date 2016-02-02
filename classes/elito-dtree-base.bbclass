ELITO_DTREE_PATH ?= "${PROJECT_TOPDIR}/files/dtree"
ELITO_DTREE_PATH[type] = "list"

FILESPATH_prepend = "${@':'.join(oe.data.typed_value('ELITO_DTREE_PATH', d))}:"

do_compile[depends] += "virtual/kernel:do_patch"
