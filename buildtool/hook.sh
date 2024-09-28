#!/bin/bash

source "$(./buildtool/__hook.nu pkg_path "$1")"

environment="$(set -o posix ; set)"
export __BASED_BUILDTOOL__="$(./buildtool/__hook.nu load "$environment")"

# Determine whether a function is defined
is_def() {
	[[ $(type -t $1) = function ]]
}

# Define all the default function wrappers
shift

for op in $@; do
	if is_def ${op}; then
		${op}
	else
		__BASED_BUILDTOOL__="${__BASED_BUILDTOOL__}" ./buildtool/__hook.nu ${op}
	fi
done
