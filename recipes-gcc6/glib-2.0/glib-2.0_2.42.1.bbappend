FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Patchset from 3fdecff96dd7516605ec9248b2a39de4db81306f
SRC_URI += "\
  file://ignore-format-nonliteral-warning.patch \
  file://0001-Do-not-ignore-return-value-of-write.patch \
  file://0002-tests-Ignore-y2k-warnings.patch \
"
