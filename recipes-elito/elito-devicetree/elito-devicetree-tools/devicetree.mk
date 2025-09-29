DTC ?= dtc
INSTALL ?= install
INSTALL_DATA = $(INSTALL) -p -m 0644

abs_top_srcdir = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

VPATH = ${abs_top_srcdir}

KERNEL_DIR ?= =/usr/src/kernel

DESTDIR ?=
pkgdatadir ?=

AM_CPP_DEPGENFLAGS = \
  -MD -MF ${@D}/.${@F}.d -MT '$@'

AM_DTC_CPPFLAGS = \
  $(AM_CPP_DEPGENFLAGS) \
  -nostdinc -undef -D__DTS__ -x assembler-with-cpp \
  -I . -I='$(MACHINE_INCDIR)' \
  -I${KERNEL_DIR}/include \
  -I${KERNEL_DTREE_DIR} \

DTC_EXTRA_FLAGS ?=
DTC_RESERVE ?= 4
DTC_PADDING_SIZE ?= 0x3000
DTB_SUFFIX ?= .dtb

ifdef DTC_FLAGS
$(error deprecated DTC_FLAGS used; rename them to DTC_BFLAGS
endif

DTC_BFLAGS = \
	$(if ${DTC_RESERVE},-R '${DTC_RESERVE}') \
	$(if ${DTC_PADDING_SIZE},-p '${DTC_PADDING_SIZE}') \
	${DTC_EXTRA_FLAGS}

DTC_OFLAGS = \
	-p 0 -@ -H epapr

define _linkfile
ln -s '$1' '$2/'

endef

_dtbs = $(addsuffix ${DTB_SUFFIX},${VARIANTS})

all:		${_dtbs}

%.dtb:	%-preproc.dts
	$(DTC) $(DTC_BFLAGS) -I dts $(abspath $<) -o $(abspath $@) -O dtb

%.dtbo:	%-preproc.dts
	$(DTC) $(DTC_OFLAGS) -I dts $(abspath $<) -o $(abspath $@) -O dtb

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
.SECONDARY:	$(patsubst %.dtbo,%-preproc.dts,${_dtbs})
