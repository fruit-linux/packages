export def configure [] {
	let configure_script = env-default configure_script './configure'
	
	let configure_args: list = env-default configure_args ''

	if $configure_args != [] {
		^$configure_script $configure_args
	} else {
		^$configure_script
	}
}

export def build [] {
	let make_cmd = env-default make_cmd 'make'
	
	let makejobs = env-default makejobs ''
	
	let make_build_args = ''
	let make_build_target = ''
	
	^$make_cmd $makejobs $make_build_args $make_build_target
}

export def check [] {
	let make_cmd = env-default make_cmd 'make'
	
		let ret = ^make -q check err>| ignore

		if ret == 0 {
		} else {
			if ret == 2 {
				print 'No target make check'
				return 0
			}
	}
}