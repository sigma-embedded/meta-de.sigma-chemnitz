include ${BUILDVAR_BUILDVARS_SCRIPT_DIR}/_generic_.mk

_vars = \
	CARGO \
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

$(call export_vars,${_vars},build build-release install install-release)

export CARGO_TARGET_DIR = ${BUILDVAR_B}/local-build
export PKG_CONFIG_ALLOW_CROSS = 1

CARGO_BUILD_FLAGS = --target ${BUILDVAR_HOST_SYS}

all:	build

build:
	${CARGO} build ${CARGO_BUILD_FLAGS}

build-release:
	${CARGO} build --release ${CARGO_BUILD_FLAGS}

install:
	${CARGO} install ${CARGO_BUILD_FLAGS} --path '.' --root '${DESTDIR}/usr' --debug --force

install-release:
	${CARGO} install ${CARGO_BUILD_FLAGS} --path '.' --root '${DESTDIR}/usr' --force
