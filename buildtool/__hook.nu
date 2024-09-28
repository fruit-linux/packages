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
		do_configure => {
			configure
		},
	}
}

