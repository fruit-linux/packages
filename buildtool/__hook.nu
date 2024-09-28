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
	
	print $a.pkgname

	#print $env_dump

	#print $env[pkgname]

	$a | to nuon
}

def main [operation: string, ...args] {
	match $operation {
		load => {
			load $args.0
		},
		pkg_path => {
			return $"./srcpkgs/($args.0)/template"
		},
		_ => {
			let build_style = $env.__BASED_BUILDTOOL__
				| from nuon
				| get build_style

			if $build_style == "gnu-configure" {
				overlay use ./styles/configure.nu
			}
			^$operation
		},
	}
}

