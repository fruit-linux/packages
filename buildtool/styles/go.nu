export def configure [] {
	if (is-empty (get_state go_import_path)) {
		error make { msg: $"$go_import_path not set on (get_state pkgname) template" }
	}

	if (get_state go_mod_mode) != 'off' and ('go.mod' | file exists) {
		print $"Building (get_state pkgname) with Go modules"
	} else {
# TODO: impl this garbage
	}
}

export def build [] {
	for wd in (get_state go_ldflags) {
		if ($wd == '-s') or ($wd == '-w') {
			error make { msg: $"(get_state pkgname): remove -s and -w from go_ldflags" }
		}
	}

# TODO: go_package := go_import_path
	
	if (get_state go_mod_mode) != 'off' and ('go.mod' | file exists) {
		#
	}
}
