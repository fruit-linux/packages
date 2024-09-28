def any-suffix-match [
	suffixes: list<string>
] {
	$suffixes | any {|suffix|
		$in | str ends-with $suffix
	}
}

def file_ext [from: string] {
	if ($from | any-suffix-match ['.tar.gz', '.tgz']) {
		'tgz'
	}
}

export def fetch_distfile [distfile_url: string] {
	let pkgname = get_state | get pkgname
	let version = get_state | get version

	let distfile_url = $distfile_url | url decode
	let extension = file_ext $distfile_url

	let outpath = $"($pkgname)-($version).($extension)"
	print $outpath
	mkdir ./work
	cd ./work
	^wget -O $"($pkgname)-($version).($extension)" $distfile_url
	^tar -xvf $outpath
}
