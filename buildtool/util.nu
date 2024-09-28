export def env-default [var: string, default: string] {
	$env
		| get -i $var
		| default $default
}

export def get_raw_state [] -> record {
	$env.__BASED_BUILDTOOL__
		| from nuon
}

export def get_state [var: string] -> string {
	get_raw_state
		| get -i $var
		| default ''
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
