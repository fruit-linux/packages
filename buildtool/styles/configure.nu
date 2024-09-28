export def do_configure [] {
	let configure_script = $env
		| get -i configure_script
		| default './configure'
	
	let configure_args: list = $env
		| get -i configure_args
		| default ''

	if $configure_args != [] {
		^$configure_script $configure_args
	} else {
		^$configure_script
	}
}

export def do_build [] {
	let make_cmd = $env
		| get -i make_cmd
		| default 'make'
	
	^$make_cmd $makejobs $make_build_args $make_build_target
}

export def do_check [] {
	if $make_cmd | is-empty; is-empty $make_check_target {
		let ret = ^make -q check err>| ignore

		if ret == 0 {
		} else {
			if ret == 2 {
				print 'No target make check'
				return 0
			}
		}
	}
}
