export const BASE_BUILDTOOL_DIR = '/home/lncn/Code/xbps-packages/xbps-packages'
# Base path for distfiles
export const DISTFILES_DIR = $"($BASE_BUILDTOOL_DIR)/distfiles"
# Base path for src
export const SRC_DIR = $"($BASE_BUILDTOOL_DIR)/src"
export const BUILD_DIR = $"($BASE_BUILDTOOL_DIR)/build"
export const PKG_DIR = $"($BASE_BUILDTOOL_DIR)/pkg"
export const STATE_DIR = $"($BASE_BUILDTOOL_DIR)/state"
export const INSTALL_DIR = $"($BASE_BUILDTOOL_DIR)/install"

export def gen-distfile-path [archive: string] -> string {
	$"($DISTFILES_DIR)/(get_state pkgname)-(get_state version)/($archive)"
}
export def gen-src-path [] -> path {
	$"($SRC_DIR)/(get_state pkgname)-(get_state version)"
}
export def gen-build-path [] -> path {
	$"($BUILD_DIR)/(get_state pkgname)-(get_state version)"
}
export def gen-state-path [] -> path {
	$"($STATE_DIR)/(get_state pkgname)-(get_state version)"
}

export def env-default [var: string, default: string] {
	$env
		| get -i $var
		| default $default
}

export def get_raw_state [] -> record {
	$env.__BASED_BUILDTOOL__
		| from nuon
}

export def get_state [var: string] -> string? {
	get_raw_state
		| get -i $var
		| default null
}

export def state-default [var: string, default: string] {
	get_state $var
		| default $default
}

export def setup_pkg [
	pkg: string
	cross?: string
	--show-problems
] {
	for v in ('PKG_BUILD_OPTIONS XBPS_CROSS_CFLAGS XBPS_CROSS_CXXFLAGS XBPS_CROSS_FFLAGS XBPS_CROSS_CPPFLAGS XBPS_CROSS_LDFLAGS XBPS_TARGET_QEMU_MACHINE' | split words) {
		$env.$v = null
	}
	for v in ('subpackages run_depends build_depends host_build_depends' | split words) {
		$env.$v = null
	}

#unset_package_funcs

	if (is-not-empty $cross) {
	} else {
		export-env {
			$env.XBPS_TARGET_MACHINE = $env
				| get -i XBPS_ARCH
				| default $env.XBPS_MACHINE
			for v in ('XBPS_CROSS_BASE XBPS_CROSS_LDFLAGS XBPS_CROSS_FFLAGS XBPS_CROSS_CFLAGS XBPS_CROSS_CXXFLAGS XBPS_CROSS_CPPFLAGS XBPS_CROSS_RUSTFLAGS XBPS_CROSS_RUST_TARGET' | split words) {
				$env.$v = null
			}
		}
	}
}

#setup_pkg musl idk --show-problems
