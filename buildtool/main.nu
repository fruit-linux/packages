#!/bin/nu

use util.nu *

def resolve-pkg [pkg: string] -> string {
	let pkg_path = $"./srcpkgs/($pkg)"
	if ($pkg_path | path exists) {
		if ($pkg_path | path type) == 'file' {
			let f = open $pkg_path
			return $f
		}
	}

	return $pkg
}

def run [
	package: string
	operations: string
] {
	let metadata: record = (^bash -c $"./buildtool/hook.sh ($package)") | from nuon

	print $metadata
	$env.__BASED_BUILDTOOL__ = $metadata | to nuon
	print (get_state makedepends)
	if (get_state makedepends) != null {
		let deps: list<string> = get_state makedepends
			| str trim
			| str replace --regex '[ \t\r\n]*' ' '
			| split row ' '
			| each {|x| $x | str trim}

		print $deps
		
		for dep in $deps {
			print $"Installing dependency ($dep)..."
			let metadata: record = (^bash -c $"./buildtool/hook.sh (resolve-pkg $dep)") | from nuon
			$env.__BASED_BUILDTOOL__ = $metadata | to nuon
			^bash -c $"__BASED_BUILDTOOL__='($metadata | to nuon)' ./buildtool/hook.sh (resolve-pkg $dep) ($operations)"
		}
	}

	^bash -c $"__BASED_BUILDTOOL__='($metadata | to nuon)' ./buildtool/hook.sh ($package) ($operations)"
}

# Build tool for Fruit Linux
def main [
	operation: string # Operation to run
	package: string   # Package to run the operation on
] {
	let operations = match $operation {
		fetch => {
			"pre_fetch do_fetch post_fetch"
		},
		extract => {
			"pre_extract do_extract post_extract"
		},
		configure => {
			"pre_configure do_configure post_configure"
		},
		build => {
			"pre_build do_build post_build"
		},
		install => {
			"pre_install do_install post_install"
		},
		package => {
			"pre_package do_package post_package"
		},
		run => {
			"pre_fetch do_fetch post_fetch pre_extract do_extract post_extract pre_configure do_configure post_configure pre_build do_build post_build"
		},
	}

	run $package $operations
}

