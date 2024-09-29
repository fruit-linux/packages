#!/bin/nu

# Nushell interface for POSIX shell hook

def do_fetch [] {
	print 'Configuring...'
}

def "main env_dump_to_nuon" [env_dump: string] {
	#print $"($env_dump)"

	$env_dump
		| parse --regex `\s*(?P<key>[^=]*)=(?P<val>('[^']*')|([^\n]*))`
		| each {|x| {$x.key: ($x.val | str trim -c "'") }}
		| into record
		| to nuon
}

def get_state [] -> record {
	$env.__BASED_BUILDTOOL__
		| from nuon
}

use styles/ *
use utils/ *

def main [operation: string, ...args] {
	match $operation {
		pkg_path => {
			return $"./srcpkgs/($args.0)/template"
		},
		pre_fetch | post_fetch => {
		},
		do_fetch => {
			fetch fetch_distfile (get_state | get distfiles)
		},
		pre_extract | post_extract => {
		},
		do_extract => {
			extract extract_distfiles (get_state | get distfiles)
		},
		_ => {
			let build_style = get_state
				| get build_style

			match $build_style {
				gnu-configure => {
					cd ./work
					gnu_configure build
				},
				cargo => {
					cd $"./work/(get_state | get pkgname)-(get_state | get version)/"
					cargo build
				},
			}
		},
	}
}

