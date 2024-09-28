use ../util.nu *

export def build [] {
	let make_cmd = env-default make_cmd 'cargo'
	let configure_args = env-default configure_args ''
	
	if (is-not-empty $configure_args) {
		(^$make_cmd build --release --locked --target $env.RUST_TARGET
			$configure_args)
	} else {
		^$make_cmd build --release --locked --target $env.RUST_TARGET
	}
}

export def check [] {
	let make_cmd = env-default make_cmd 'cargo auditable'
	let configure_args = env-default configure_args ''
	let make_check_pre = env-default make_check_pre ''
	let make_check_args = env-default make_check_args ''

	(^$make_check_pre $make_cmd test --release --locked --target $env.RUST_TARGET
		$configure_args $make_check_args)
}

export def install [] {
	let make_cmd = env-default make_cmd 'cargo auditable'
	let configure_args = env-default configure_args ''
	let make_install_args = env-default make_install_args '--path .'

	(^$make_cmd install --target $env.RUST_TARGET --root=$"($env.DESTDIR)/usr"
		--offline --locked $configure_args $make_install_args)

	rm -f $"($env.DESTDIR)/usr/.crates.toml"
	rm -f $"($env.DESTDIR)/usr/.crates2.json"
}
