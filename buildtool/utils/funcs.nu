use ../util.nu *

export def "main vmove" [
	files: string,
] {
	for f in ($files | split words) {

	}
}

export def "main vmkdir" [
	dir: string,
	mode?: string,
] {
	if (is-empty $mode) {
		install -d $"($PKG_DIR)/($dir)"
	} else {
		install $"-dm($mode)" $"($PKG_DIR)/($dir)"
	}
}

export def "main vcompletion" [
	file: string,
	shell: string,
	cmd: string,
] {
	error make { msg: 'vcompletion is a noop' }
}
