include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

BUILDVAR_CARGO_BUILD_TARGET ?= ${BUILDVAR_RUST_HOST_SYS}

_vars = \
	CARGO \
	CARGO_BUILD_TARGET \
	CARGO_HOME \
	CARGO_TARGET_SUBDIR \
	CC \
	CXX \
	TARGET_CC \
	TARGET_CXX \
	HOST_CC \
	HOST_CXX \
	RUST_TARGET_PATH \
	RUSTFLAGS \

$(call export_vars,${_vars},\
	${SHELL_TARGET} \
	.cargo.build .cargo.build-release .cargo.install .cargo.install-release .cargo.test \
	.cargo.cbuild .cargo.cbuild-release .cargo.cinstall .cargo.cinstall-release .cargo.ctest \
)

export CARGO_TARGET_DIR = ${BUILDVAR_B}/local-build
export PKG_CONFIG_ALLOW_CROSS = 1

CARGO_LOCAL_CONF ?=
CARGO_INSTALL_PATH ?= .

CARGO_BUILD_FLAGS += \
	--target ${BUILDVAR_RUST_HOST_SYS} \
	--offline \

CARGO_CBUILD_FLAGS += \
	--target '${BUILDVAR_RUST_TARGET_SYS}' \
	--offline \
	--destdir '${DESTDIR}' \
	--prefix '${BUILDVAR_prefix}' \
	--libdir='${BUILDVAR_libdir}' \

all:

cargo.%:			FORCE
	@$(if ${ORIG_MAKE},true,echo "***** ORIG_MAKE not defined *****"; exit 1)
	+${ORIG_MAKE} -e .$@

### default 'build' + 'install' targets

.cargo.build:			FORCE
	${CARGO} build ${CARGO_BUILD_FLAGS}

.cargo.build-release:		FORCE
	${CARGO} build --release ${CARGO_BUILD_FLAGS}

.cargo.install:			FORCE
	${CARGO} install ${CARGO_BUILD_FLAGS} --path '${CARGO_INSTALL_PATH}' --root '${DESTDIR}/usr' --debug --force

.cargo.install-release:		FORCE
	${CARGO} install ${CARGO_BUILD_FLAGS} --path '${CARGO_INSTALL_PATH}' --root '${DESTDIR}/usr' --force

.cargo.test:			FORCE
	${CARGO} test ${CARGO_BUILD_FLAGS}

### cargo-c 'build' + 'install' targets

.cargo.cbuild:			FORCE
	${CARGO} cbuild ${CARGO_CBUILD_FLAGS}

.cargo.cbuild-release:		FORCE
	${CARGO} build --release ${CARGO_CBUILD_FLAGS}

.cargo.cinstall:		FORCE
	${CARGO} cinstall ${CARGO_CBUILD_FLAGS}

.cargo.cinstall-release:	FORCE
	${CARGO} cinstall ${CARGO_CBUILD_FLAGS}

.cargo.ctest:			FORCE
	${CARGO} ctest ${CARGO_CBUILD_FLAGS}

${BUILDVAR_CARGO_HOME}/.dirstamp:
	mkdir -p '${@D}'
	touch '$@'

## $(call cargo_local_conf,<cargo-local.conf>)
cargo_local_conf = $(eval $(call _cargo_local_conf,$1))

define _cargo_local_conf
ORIG_CARGO_HOME    := $${BUILDVAR_CARGO_HOME}
ORIG_CARGO_CONFIG  ?= $$(wildcard $${ORIG_CARGO_HOME}/config.toml)
BUILDVAR_CARGO_HOME = $${CARGO_TARGET_DIR}/.home

_SED_CARGO_LOCAL_CONF = sed \
	-e '/^\[patch\./,$$$$d' \

$${BUILDVAR_CARGO_HOME}/config.toml: | $${BUILDVAR_CARGO_HOME}/.dirstamp
$${BUILDVAR_CARGO_HOME}/config.toml: $${ORIG_CARGO_CONFIG} $1
	rm -f $$@ $$@.tmp
	{ \
		$${_SED_CARGO_LOCAL_CONF} < '$$(filter %/config.toml,$$^)' && \
		cat '$$(filter %$1,$$^)'; \
	} > '$$@'.tmp
	mv '$$@'.tmp '$$@'

.SECONDARY:		$${BUILDVAR_CARGO_HOME}/config.toml

.cargo.build \
.cargo.build-release \
.cargo.install \
.cargo.install-release \
.cargo.cbuild \
.cargo.cbuild-release \
.cargo.cinstall \
.cargo.cinstall-release \
.cargo.test:		$${BUILDVAR_CARGO_HOME}/config.toml
endef				# cargo_local_conf
