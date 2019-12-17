FSLIOMUX = fsliomux-conv

VARIANTS = $(MACHINE)
UART =		uart2
DCD_DEVICES =	mmdc

pkginclude_DATA = $(foreach v,$(VARIANTS), $v-dcd.h $v-main.h $v-dts-pins.h)

_run_fsliomux = ${FSLIOMUX} -d "${@D}/.${@F}.deps.tmp" -o '$@.tmp' $1 -- $<
_preproc_deps = rm -f "${@D}/.${@F}.deps.tmp"
_postproc_deps = \
  rm -f "${@D}/.${@F}.deps" && \
  { echo "$@: \\" && \
  cat "${@D}/.${@F}.deps.tmp" && \
  echo; } > "${@D}/.${@F}.deps" && \
  rm -f "${@D}/.${@F}.deps.tmp"

all:	$(pkginclude_DATA)

%-dcd.h:	%-iomux.xml
	@rm -f $@ $@.tmp
	@$(call _preproc_deps)
	$(call _run_fsliomux,-F c -m fn -O '${DCD_DEVICES} ${UART}')
	@$(call _postproc_deps)
	@chmod a-w $@.tmp
	@mv $@.tmp $@

%-main.h:	%-iomux.xml
	@rm -f $@ $@.tmp
	@$(call _preproc_deps)
	$(call _run_fsliomux,-F c -m fn -D '${DCD_DEVICES} ${UART}')
	@$(call _postproc_deps)
	@chmod a-w $@.tmp
	@mv $@.tmp $@

.SECONDEXPANSION:

%-dts-pins.h:	%-iomux.xml %-postproc.sh $$(SOC_DTREE_PINS_%)
	@rm -f $@ $@.tmp
	@$(call _preproc_deps)
	$(call _run_fsliomux,-F dtree -m fn -D '${DCD_DEVICES}' -M '$(filter %.h,$^)' -P '$(abspath $(filter %-postproc.sh,$^))')
	@$(call _postproc_deps)
	@chmod a-w $@.tmp
	@mv $@.tmp $@

%-postproc.sh:
	test -s '$@' || { rm -f '$@' && echo '#! /bin/sh' > $@; chmod a+x '$@'; }

install:	$(pkginclude_DATA)
	install -d -m 0755 ${DESTDIR}${pkgincludedir}
	install -p -m 0644 $(filter %.h,$^) ${DESTDIR}${pkgincludedir}/

-include $(foreach v,$(VARIANTS), .$v-dcd.h.deps .$v-main.h.deps .$v-dts-pins.h.deps)
