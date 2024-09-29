def fix-file-ext [from_suffixes: list<string>, to_suffix: string] -> string {
	let input: string = $in
	for suffix in $from_suffixes {
		if ($input | str ends-with $suffix) {
			return ($input | str replace $suffix $to_suffix)
		}
	}
	return $input
}

export def fix-file-exts [] -> string {
	$in
		| fix-file-ext ['tar.gz'] tgz
		| fix-file-ext ['tar.bz2'] tbz
		| fix-file-ext ['tar.xz', 'tar.lzma'] txz
		| fix-file-ext ['tar.zst'] tzst
}
	

export def fetch_distfile [distfile_url: string] {
	let pkgname = get_state | get pkgname
	let version = get_state | get version

	let fname = ($distfile_url | split row '/') | last

	let outpath = $fname | fix-file-exts

	mkdir ./work
	cd ./work
	
	^wget -O $"($outpath)" $distfile_url
}
