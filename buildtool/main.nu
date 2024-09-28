#!/bin/nu

def "main load" [
	package: string
] {
	^bash -c $"source ./srcpkgs/($package)/template && ./buildtool/hook.sh ($package) do_configure"
}

# Build tool for Based Linux
def main [
	operation: string # Operation to run
	package: string   # Package to run the operation on
] {
	match $operation {
		build => {}
		install => {}
		package => {}
	}
}

