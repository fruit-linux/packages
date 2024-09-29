use ../util.nu *

export def configure [] {
	mut cmake_args = ''

	let cmake_builddir = get_state cmake_builddir
		| default 'build'
	
	if !($cmake_builddir | file exists) {
		mkdir $cmake_builddir
	}
	cd $cmake_builddir

	if (is-not-empty (get_state CHROOT_READY)) {
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

	cmake_args += ' -DCMAKE_INSTALL_PREFIX:PATH=/usr'
	cmake_args += ' -DCMAKE_BUILD_TYPE=None'
	cmake_args += ' -DCMAKE_INSTALL_LIBDIR:PATH=lib${XBPS_TARGET_WORDSIZE}'
	cmake_args += ' -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc'

	cmake_args += ' -DCMAKE_INSTALL_SBINDIR:PATH=bin'

	$env.CMAKE_GENERATOR = (env-default CMAKE_GENERATOR 'Ninja')

	# Remove -pipe: https://gitlab.kitware.com/cmake/cmake/issues/19590
	CFLAGS="-DNDEBUG ${CFLAGS/ -pipe / }" CXXFLAGS="-DNDEBUG ${CXXFLAGS/ -pipe / }" \
		cmake $cmake_args $configure_args \
		${LIBS:+-DCMAKE_C_STANDARD_LIBRARIES="$LIBS"} \
		${LIBS:+-DCMAKE_CXX_STANDARD_LIBRARIES="$LIBS"} \
		${wrksrc}/${build_wrksrc}

	# Replace -isystem with -I
	if ($env | get CMAKE_GENERATOR) == "Unix Makefiles" {
		^find . -name flags.make -exec sed -i -e 's/-isystem/-I/g' "{}" +
	} else if ($env | get CMAKE_GENERATOR) == 'Ninja' {
		^sed -i -e 's/-isystem/-I/g' build.ninja
	}
}

export def build [] {
	let make_cmd = (env-default make_cmd 'ninja')

	cd (env-default cmake_builddir 'build')
	$make_cmd 
