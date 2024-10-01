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

use util.nu *
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
			fetch fetch_distfile (get_state distfiles)
		},
		pre_extract | post_extract => {
		},
		do_extract => {
			extract extract_distfiles (get_state distfiles)
		},
		pre_configure | post_configure => {
		},
		do_configure => {
			match (get_state build_style) {
				gnu-configure => {
					cd $"./src/(get_state pkgname)-(get_state version)/"
					gnu-configure configure
				},
				cargo => {
					cd $"./src/(get_state pkgname)-(get_state version)/"
					cargo configure
				},
				cmake => {
					cd $"./src/(get_state pkgname)-(get_state version)/"
					cmake configure
				},
			}
		},
		pre_build | post_build => {
		},
		do_build => {
			match (get_state build_style) {
				gnu-configure => {
					cd $"./src/(get_state pkgname)-(get_state version)/"
					gnu-configure build
				},
				cargo => {
					cd $"./src/(get_state pkgname)-(get_state version)/"
					cargo build
				},
				cmake => {
					cd $"./src/(get_state pkgname)-(get_state version)/"
					cmake build
				},
			}
		},
		pre_install | post_install => {
		},
		do_install => {
			match (get_state build_style) {
				gnu-configure => {
					//
				},
			}
		},
	}
}

