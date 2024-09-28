#!/bin/bash

source "$(./buildtool/__hook.nu pkg_path "$1")"

environment="$(set -o posix ; set)"
export __BASED_BUILDTOOL__="$(./buildtool/__hook.nu load "$environment")"

# Determine whether a function is defined
is_def() {
	[[ $(type -t $1) = function ]]
}

# Define all the default function wrappers
for op in build check configure extract fetch install patch setup; do
	for prefix in pre "do" post; do
		if ! is_def ${op}; then
			eval "
			${prefix}_${op}() {
				./buildtool/__hook.nu ${prefix}_${op}
			}
			"
		fi
	done
done

shift

# Carry out operations
for op in $@; do
	$op
done
