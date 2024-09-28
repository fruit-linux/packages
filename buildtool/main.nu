#!/bin/nu

def run [
	package: string
	operations: string
] {
	let metadata: record = (^bash -c $"./buildtool/hook.sh ($package)") | from nuon
	print $metadata
	#let metadata = (^bash -c $"./buildtool/hook.sh ($package) ($operations)")
}

# Build tool for Based Linux
def main [
	operation: string # Operation to run
	package: string   # Package to run the operation on
] {
	let operations = match $operation {
		build => {
			"pre_build do_build post_build"
		},
		install => {
			"pre_install do_install post_install"
		},
		package => {
			"pre_package do_package post_package"
		},
	}

	run $package $operations
}

