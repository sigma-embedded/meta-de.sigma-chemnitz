export PATH := ${BUILDVAR_PATH}:${PATH}

SHELL_TARGET ?= shell
EXEC_TARGET ?= exec
SHELL_SHELL ?= bash -l
SHELL_VARIABLES = \
	CC CFLAGS CPPFLAGS LDFLAGS PS1 WORKDIR

SHELL_PS1 ?= [\[\033[1;34m\]${BUILDVAR_PN}\[\033[0;39m\]|\u@\h \W]\044\040

.DEFAULT_GOAL = all

_common_vars =

define _export_var
export $1 = $${BUILDVAR_$1}
endef

define _export_var_target
$2:	export $1 = $${BUILDVAR_$1}
endef

## Usage: $(call export_vars, <variables>, [<targets>])
export_vars = $(foreach v,$1 x,$(eval \
	$(call $(if $2,_export_var_target,_export_var),$v,$2)))

$(call export_vars,${SHELL_VARIABLES},${SHELL_TARGET})

$(call export_vars,${_common_vars})

${SHELL_TARGET}: FORCE
	@${SHELL_SHELL}

${EXEC_TARGET}: FORCE
	$C

.generic-help:	FORCE
	@echo "   shell  ... enters an interactive shell"
	@echo "   exec   ... executes $$C within cross environment"

FORCE:
.PHONY:	FORCE
