def any-suffix-match [
	suffixes: list<string>
] {
	$suffixes | any {|suffix|
		$in | str ends-with $suffix
	}
}

def fix_file_ext [from: string] -> string {
	if ($from | any-suffix-match ['.tar.gz', '.tgz']) {
		return ($from | str replace 'tar.gz' 'tgz')
	}
}

export def fetch_distfile [distfile_url: string] {
	let pkgname = get_state | get pkgname
	let version = get_state | get version

	let fname = ($distfile_url | split row '/') | last

	let outpath = fix_file_ext $fname
	mkdir ./work
	cd ./work
	^wget -O $"($outpath)" $distfile_url
}
