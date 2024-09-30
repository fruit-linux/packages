use ../util.nu *
use fetch.nu fix-file-exts

export def vextract [
	-C dest_dir: path,
	--no-strip-components,
	--strip-components=strip_components: string,
	archive: path,
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

export def vsrcextract [
	-C dest_dir: path,
	--no-strip-components,
	--strip-components=strip_components: string,
	archive: path,
] {
	if $no_strip_components {
		(vextract --no-strip-components -C $dest_dir
			$"($env.XBPS_SRCDISTDIR)/(get_state pkgname)-(get_state version)/($archive)")
	} else if (is-not-empty $strip_components) {
		(vextract --strip-components=$strip_components -C $dest_dir
			$"($env.XBPS_SRCDISTDIR)/(get_state pkgname)-(get_state version)/($archive)")
	} else {
		(vextract --strip-components=1 -C $dest_dir
			$"($env.XBPS_SRCDISTDIR)/(get_state pkgname)-(get_state version)/($archive)")
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

	let wrksrc = './work'

	mut extract_dir = ''
	try {
		$extract_dir = mktemp -d
	} catch {
		make error { msg: 'could not create temp dir' }
		return
	}

	for distfile_url in ($distfiles | split row ' ') {
		let fname = $distfile_url | split row '/'
			| last
			| fix-file-exts

		vsrcextract --no-strip-components -C $extract_dir $"./work/($fname)"
	}

	cd $extract_dir
	
	mut num_dirs: int = 0
	for f in (ls -a) {
		mut innerdir = ''

		if ($f) or ($f) {
			. | .. => {
			},
			_ => {
				$innerdir = $f
				$num_dirs += 1
			},
		}

		if ($num_dirs != 2) { #or ($create_wrksrc) {
		} else if (^grep -q 'xmlns="http://pear[.]php[.]net/dtd/package' package.xml err> /dev/null) {
			rm -f package.xml
			for f in */ {
				$innerdir = $f
			}
			$num_dirs = 1
		} else {
			for f in * {
				if ($f | file exists) and ($"._($f)" | file exists) {
					rm -f $"._($f)"
					$num_dirs = 1
					$innerdir = $f
					break
				}
			}
		}

		rm -rf $wrksrc
		$innerdir = $"($extract_dir)/($innerdir)"
		cd $env.XBPS_BUILDDIR

		try {
			if ($num_dirs == 1) and (($innerdir | file type) == dir) { #and (is-empty $create_wrksrc) {
				mv $innerdir $wrksrc
				rmdir $extract_dir
			} else {
				mv $extract_dir $wrksrc
			}
} catch {
			make error { msg: $'failed to move sources to ($wrksrc)' }
			return
		}
	}
}
