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
	cargo.build cargo.build-release cargo.install cargo.install-release \
	.cargo.build .cargo.build-release .cargo.install .cargo.install-release \
)

export CARGO_TARGET_DIR = ${BUILDVAR_B}/local-build
export PKG_CONFIG_ALLOW_CROSS = 1

CARGO_BUILD_FLAGS = --offline --target ${BUILDVAR_HOST_SYS}

all:	build

build build-release install install-release:%:	cargo.%
	@:

cargo.%:		FORCE
	@$(if ${ORIG_MAKE},true,echo "***** ORIG_MAKE not defined *****"; exit 1)
	+${ORIG_MAKE} -e .$@

.cargo.build:		FORCE
	${CARGO} build ${CARGO_BUILD_FLAGS}

.cargo.build-release:	FORCE
	${CARGO} build --release ${CARGO_BUILD_FLAGS}

.cargo.install:		FORCE
	${CARGO} install ${CARGO_BUILD_FLAGS} --path '.' --root '${DESTDIR}/usr' --debug --force

.cargo.install-release:	FORCE
	${CARGO} install ${CARGO_BUILD_FLAGS} --path '.' --root '${DESTDIR}/usr' --force
