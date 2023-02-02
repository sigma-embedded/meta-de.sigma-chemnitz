FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

## already in OE since 2021-10-05 but see below...
SRC_URI += "\
    file://parallel-make.patch;maxver=9.4 \
"

## remove the corresponding OE patch to keep compatibility with projects
## which have not been updated to recent OE yet
SRC_URI_remove = "\
    file://0040-fix-missing-dependencies-for-selftests.patch \
"
