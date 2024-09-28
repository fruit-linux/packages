#!/bin/nu

# Nushell interface for POSIX shell hook

def configure [] {
	print 'Configuring...'
}

def load [env_dump: string] {
	let a = $env_dump
		| split row "\n"
		| parse '{key}={val}'
		| each {|x| {$x.key: $x.val}}
		| into record
	
	#print $env_dump

	#print $env[pkgname]

	$a | to nuon
}

def get_state [] -> record {
	$env.__BASED_BUILDTOOL__
		| from nuon
}

use styles/ *
use utils/ fetch

def main [operation: string, ...args] {
	match $operation {
		load => {
			load $args.0
		},
		pkg_path => {
			return $"./srcpkgs/($args.0)/template"
		},
		_ => {
			let build_style = get_state
				| get build_style

			fetch fetch_distfile (get_state | get distfiles)

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

