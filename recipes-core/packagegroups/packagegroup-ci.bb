## due to BBFILE_PRIORITY a -ci layer will take precedence and overrides
## our packages.  Provide a stub .bb here and put logic into a .bbeppend.

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup
