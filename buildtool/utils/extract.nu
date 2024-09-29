use ../util.nu *
use fetch.nu fix-file-exts

export def vextract [
	-C dest_dir: path,
	--no-strip-components,
	--strip-components=strip_components: string,
	archive: string,
] {
	print $archive
	let extension = ($"./work/($archive)" | path parse).extension
	mut sc = '--strip-components=1'
	mut dst = ''

	if $no_strip_components {
		$sc = ''
	}
	if (is-not-empty $strip_components) {
		$sc = $"--strip-components=($strip_components)"
	}

	let tar_cmd = get_state tar_cmd
		| default 'tar'
	
	print $"ext: ($extension)"
	match $extension {
		tar | txz | tbz | tlz | tgz | tzst | crate => {
			mut args: list<string> = []

			if (is-not-empty $sc) {
				$args += [$sc]
			}
			if (is-not-empty $dst) {
				$args += [-C, $dst]
			}
			$args = $args | append [-x, --no-same-permissions, --no-same-owner, -f, $archive]

			^$tar_cmd ...$args
		},
	}
}

export def extract_distfiles [distfiles: string] {
	#let srcdir = $"./work/(get_state pkgname)-(get_state version)"

	#if (is-not-empty (get_state distfiles)) and (is-not-empty (get_state checksum)) {
	#	mkdir ./work
	#	return
	#}

	#if ($srcdir | file exists) {
	#	return
	#}

	cd ./work

	try {
		let extract_dir = mktemp -d
	} catch {
		make error { msg: 'could not create temp dir' }
		return
	}

	for distfile_url in ($distfiles | split row ' ') {
		let fname = $distfile_url | split row '/'
			| last
			| fix-file-exts

		let extract_dir = './work'
		vextract --no-strip-components -C $extract_dir $"($fname)"
	}
}
