use ../util.nu *

export def configure [] {
	mut cmake_args = ''

	let cmake_builddir = state-default cmake_builddir (gen-build-path)
	
	#if !($cmake_builddir | file exists) {
		mkdir $cmake_builddir
	#}
	cd $cmake_builddir

	if (is-not-empty (get_state CHROOT_READY | default '')) {
		$"
SET\(CMAKE_SYSTEM_NAME Linux)
SET\(CMAKE_SYSTEM_VERSION 1)

SET\(CMAKE_C_COMPILER   (get_state CC))
SET\(CMAKE_CXX_COMPILER (get_state CXX))

SET\(CMAKE_FIND_ROOT_PATH  \"(get_state XBPS_MASTERDIR)/usr;(get_state XBPS_MASTERDIR)\")

SET\(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET\(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
"
		$env.configure_args += ' -DCMAKE_TOOLCHAIN_FILE=bootstrap.cmake'
# TODO: add cross build support
	}

	$cmake_args += ' -DCMAKE_INSTALL_PREFIX:PATH=/usr'
	$cmake_args += ' -DCMAKE_BUILD_TYPE=None'
	$cmake_args += ' -DCMAKE_INSTALL_LIBDIR:PATH=lib' # ${XBPS_TARGET_WORDSIZE}'
	$cmake_args += ' -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc'

	$cmake_args += ' -DCMAKE_INSTALL_SBINDIR:PATH=bin'

	$env.CMAKE_GENERATOR = (env-default CMAKE_GENERATOR 'Ninja')

	# Remove -pipe: https://gitlab.kitware.com/cmake/cmake/issues/19590
	$env.CFLAGS = $"-DNDEBUG ($env | get -i CFLAGS | default '' | str replace ' -pipe ' ' ')"
	$env.CXXFLAGS = $"-DNDEBUG ($env | get -i CXXFLAGS | default '' | str replace ' -pipe ' ' ')"
	(^cmake -S (gen-src-path) -B (gen-build-path) $cmake_args #($env | get -i configure_args | default '')
		#-DCMAKE_C_STANDARD_LIBRARIES=$LIBS
		#-DCMAKE_CXX_STANDARD_LIBRARIES=$LIBS
		$"../")

	# Replace -isystem with -I
	if ($env | get CMAKE_GENERATOR) == "Unix Makefiles" {
		^find . -name flags.make -exec sed -i -e 's/-isystem/-I/g' "{}" +
	} else if ($env | get CMAKE_GENERATOR) == 'Ninja' {
		^sed -i -e 's/-isystem/-I/g' build.ninja
	}
}

export def build [] {
	let make_cmd = (state-default make_cmd 'ninja')

	cd (state-default cmake_builddir (gen-build-path)) #(env-default cmake_builddir 'build')

	mut args = []

	if (is-not-empty (get_state make_build_args | default '')) {
		$args += [get_state make_build_args]
	}

	if (is-not-empty (get_state make_build_target | default '')) {
		$args += [get_state make_build_target]
	}

	^$make_cmd ...$args
}

export def install [] {
	let make_cmd = (state-default make_cmd 'ninja')
	let make_install_target = (state-default make_install_target 'install')

	cd (state-default cmake_builddir (gen-build-path)) #(env-default cmake_builddir 'build')
	
	$env.DESTDIR = (env-default DESTDIR $INSTALL_DIR)

	^$make_cmd $make_install_target
}
