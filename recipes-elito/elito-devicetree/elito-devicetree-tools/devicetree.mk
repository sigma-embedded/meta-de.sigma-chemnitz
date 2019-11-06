DTC ?= dtc
INSTALL ?= install
INSTALL_DATA = $(INSTALL) -p -m 0644

abs_top_srcdir = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

VPATH = ${abs_top_srcdir}

KERNEL_DIR ?= =/usr/src/kernel

AM_CPP_DEPGENFLAGS = \
  -MD -MF ${@D}/.${@F}.d -MT '$@'

AM_DTC_CPPFLAGS = \
  $(AM_CPP_DEPGENFLAGS) \
  -nostdinc -undef -x assembler-with-cpp \
  -I . -I='$(MACHINE_INCDIR)' \
  -I${KERNEL_DIR}/include \
  -I${KERNEL_DTREE_DIR} \

DTC_RESERVE ?= 4
DTC_FLAGS = -R ${DTC_RESERVE}

define _linkfile
ln -s '$1' '$2/'

endef

_dtbs = $(addsuffix .dtb,${VARIANTS})

all:		${_dtbs}

%.dtb:	%-preproc.dts
	$(DTC) $(DTC_FLAGS) -I dts $(abspath $<) -o $(abspath $@) -O dtb

%-preproc.dts:	%.dts
	@-rm -f $@
	$(CPP) $(DTC_CPPFLAGS) $(AM_DTC_CPPFLAGS) -o $@ $<
	@chmod a-w '$@'

-include $(foreach v,$(VARIANTS),.$v-preproc.dts.d)

$(DESTDIR)$(pkgdatadir):
	$(INSTALL) -d -m 0755 $@

install:	${_dtbs} | $(DESTDIR)$(pkgdatadir)
	$(INSTALL_DATA) $^ $(DESTDIR)$(pkgdatadir)/

clean:
	rm -f ${_dtbs}

.SECONDARY:	$(patsubst %.dtb,%-preproc.dts,${_dtbs})
