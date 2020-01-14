## SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only
##
## OE part of the sstate-server server
##
## https://gitlab-ext.sigma-chemnitz.de/ensc/sstate-server
##
##
## Usage:
##
## make sstate-session \
##       SSTATE_SERVER_TOKEN=some-token \
##       SSTATE_SERVER_API=http://....
##
## Both parameters can be stored into
##    ~/.config/openembedded/sstate-server.mk
##

_SSTATE_SERVER_SESSION_FILE =	${BUILDDIR}/.sstate-server-session

-include ${HOME}/.config/openembedded/sstate-server.mk
-include ${_SSTATE_SERVER_SESSION_FILE}.mk

_sstate_server_curl =	curl -sSf '${SSTATE_SERVER_API}$2' $(if $1,-H 'X-Session: $1') $3
sstate_server_curl =	$(call _sstate_server_curl,${SSTATE_SERVER_SESSION},$1,$2)

sstate-check:

## Step 1: create the session; this requires SSTATE_SERVER_TOKEN
ifeq (${SSTATE_SERVER_TOKEN},)

sstate-session: FORCE
	@echo "=======================================================" >&2
	@echo "ERROR: sstate-server token not defined; please execute" >&2
	@echo >&2
	@echo "  echo > ~/.config/openembedded/sstate-server.mk 'SSTATE_SERVER_TOKEN = ...'" >&2
	@echo >&2
	@echo "and retry the command." >&2
	@echo "=======================================================" >&2
	@exit 1

else     # non-empty SSTATE_SERVER_TOKEN

_SSTATE_SERVER_API ?=		http://ensc-virt.intern.sigma-chemnitz.de:21001/api
_SSTATE_SERVER_GIT_BRANCH =	$(shell git rev-parse --abbrev-ref HEAD)
_SSTATE_SERVER_GIT_REF =	$(shell git rev-parse HEAD)
__SSTATE_SERVER_DISTRO_RH =	sed 's!^\([^ ]\+\) release \([0-9]\+\).*!\1 \2!' /etc/redhat-release
__SSTATE_SERVER_DISTRO_LSB =	source /etc/lsb-release && echo "$${DISTRIB_ID} $${DISTRIB_RELEASE}"

_SSTATE_SERVER_DISTRO =		$(shell if   test -e /etc/lsb-release;    then ${__SSTATE_SERVER_DISTRO_LSB}; \
					elif test -e /etc/redhat-release; then ${__SSTATE_SERVER_DISTRO_RH}; \
					else echo ""; fi)

SSTATE_SERVER_SESSION_PING_PARAMS = \
	-H 'X-Session: ${SSTATE_SERVER_SESSION}'

SSTATE_SERVER_SESSION_NEW_PARAMS = \
	-X POST \
	-H 'X-Token: ${SSTATE_SERVER_TOKEN}'\
	-H 'X-Branch: ${_SSTATE_SERVER_GIT_BRANCH}' \
	-H 'X-Ref: ${_SSTATE_SERVER_GIT_REF}' \
	-H 'X-Distro: ${_SSTATE_SERVER_DISTRO}' \
	$(if ${SSTATE_SERVER_SESSION},-H "X-Try-Session: ${SSTATE_SERVER_SESSION}")

sstate-session:	FORCE
	@rm -f ${_SSTATE_SERVER_SESSION_FILE}.tmp
	${Q}$(call _sstate_server_curl,,/v1/session/new,${SSTATE_SERVER_SESSION_NEW_PARAMS} --output ${_SSTATE_SERVER_SESSION_FILE}.tmp)
	@rm -f ${_SSTATE_SERVER_SESSION_FILE}.mk
	@echo 'export SSTATE_SERVER_API = ${SSTATE_SERVER_API}'		                                              > ${_SSTATE_SERVER_SESSION_FILE}.mk
	@sed 's!^session=\([0-9a-zA-Z]\+\)!export SSTATE_SERVER_SESSION = \1!p;d' ${_SSTATE_SERVER_SESSION_FILE}.tmp >> ${_SSTATE_SERVER_SESSION_FILE}.mk
	@sed 's!^dlpath=\([0-9a-zA-Z]\+\)!export SSTATE_SERVER_PATH = \1!p;d'     ${_SSTATE_SERVER_SESSION_FILE}.tmp >> ${_SSTATE_SERVER_SESSION_FILE}.mk
	@rm -f ${_SSTATE_SERVER_SESSION_FILE}.tmp
	@echo "session created"

endif

## Step 2: operate on an existing session
ifneq (${SSTATE_SERVER_SESSION},)

SSTATE_CHECK_TARGETS += all bitbake image

BB_ENV_EXTRAWHITE += \
	SSTATE_SERVER_PATH SSTATE_SERVER_SESSION SSTATE_SERVER_API \
	BB_GENERATE_MIRROR_TARBALLS

export BB_GENERATE_MIRROR_TARBALLS = 1
export BB_ENV_EXTRAWHITE

__SSTATE_SERVER_DISABLE_OPTS = \
	push pull

__SSTATE_SERVER_FILTER_OPTS = \
	same-project same-branch same-distro same-lsb \
	owner non-guest

$(addprefix sstate-disable-,${__SSTATE_SERVER_DISABLE_OPTS}):sstate-disable-%:	FORCE
	${Q}$(call sstate_curl,/v1/session/disable/$*,-X POST)

$(addprefix sstate-filter-,${__SSTATE_SERVER_FILTER_OPTS}):sstate-filter-%:	FORCE
	${Q}$(call sstate_server_curl,/v1/session/filter/$*,-X POST)

${SSTATE_CHECK_TARGETS}:	sstate-check

sstate-check:	FORCE
	${Q}$(call _sstate_server_curl,,/v1/session/ping,${SSTATE_SERVER_SESSION_PING_PARAMS} --output /dev/null)

sstate-close:	FORCE
	${Q}$(call sstate_server_curl,/v1/session/close,-X POST)

endif
