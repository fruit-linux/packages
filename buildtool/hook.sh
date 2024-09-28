#!/bin/bash

source "$(./buildtool/__hook.nu pkg_path "$1")"

# If no operations were specified, load env vars
# Otherwise carry out the specified operations
if [ $# -lt 2 ]; then
	environment="$(set -o posix ; set)"
	./buildtool/__hook.nu env_dump_to_nuon "$environment"
else
	# Determine whether a function is defined
	is_def() {
		[[ $(type -t $1) = function ]]
	}
	
	shift
	
	for op in $@; do
		if is_def ${op}; then
			${op}
		else
			./buildtool/__hook.nu ${op}
		fi
	done
fi
