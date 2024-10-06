use util.nu *

export def setup_pkg_depends [
	pkg?: string,
	out: string,
	with_subpkgs?: string,
] {
	if (is-not-empty $pkg) {
		if 
}

export def install_pkg_from_repos [
	cross: string,
	target: string,
	...args
] {
	if ($args | count) == 0 {
		return 0
	}

	mkdir $STATE_DIR
	let tmplogf = $"($STATE_DIR)/xbps_('x86_64')_bdep_($env.pkg).log"
	let cmd = 'xbps-install'
}
