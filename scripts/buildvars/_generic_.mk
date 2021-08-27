export PATH := ${BUILDVAR_PATH}:${PATH}

SHELL_TARGET ?= shell
EXEC_TARGET ?= exec
SHELL_SHELL ?= bash -l

SHELL_PS1 ?= [\[\033[1;34m\]${BUILDVAR_PN}\[\033[0;39m\]|\u@\h \W]\044\040

.DEFAULT_GOAL = all

define _export_var
export $1 = $${BUILDVAR_$1}
endef

define _export_var_target
$2:	export $1 = $${BUILDVAR_$1}
endef

## Usage: $(call export_vars, <variables>, [<targets>])
export_vars = $(foreach v,$1 x,$(eval \
	$(call $(if $2,_export_var_target,_export_var),$v,$2)))

${SHELL_TARGET}: export CC=${BUILDVAR_CC}
${SHELL_TARGET}: export CFLAGS=${BUILDVAR_CFLAGS}
${SHELL_TARGET}: export CPPFLAGS=${BUILDVAR_CPPFLAGS}
${SHELL_TARGET}: export LDFLAGS=${BUILDVAR_LDFLAGS}
${SHELL_TARGET}: export PS1=${SHELL_PS1}
${SHELL_TARGET}: export WORKDIR=${BUILDVAR_WORKDIR}
${SHELL_TARGET}: FORCE
	@${SHELL_SHELL}

${EXEC_TARGET}: FORCE
	$C

.generic-help:	FORCE
	@echo "   shell  ... enters an interactive shell"
	@echo "   exec   ... executes $$C within cross environment"

FORCE:
.PHONY:	FORCE
