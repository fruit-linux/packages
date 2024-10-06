use ../util.nu *

export def configure [] {
	let meson_cmd = state-default meson_cmd 'meson'
	let meson_builddir = state-default meson_builddir 'build'
	
	export-env {
		$env.AR = 'gcc-ar'
	}

	(^$meson_cmd setup
		--prefix=/usr
		$"--libdir=/usr/lib"   #($XBPS_TARGET_WORDSIZE)"
		--libexecdir=/usr/libexec
		--bindir=/usr/bin
		--sbindir=/usr/bin
		--includedir=/usr/include
		--datadir=/usr/share
		--mandir=/usr/share/man
		--infodir=/usr/share/info
		--localedir=/usr/share/locale
		--sysconfdir=/etc
		--localstatedir=/var
		--sharedstatedir=/var/lib
		--buildtype=plain
		--auto-features=auto
		--wrap-mode=nodownload
		-Db_lto=true -Db_ndebug=true
		-Db_staticpic=true
		(get_state configure_args) . $meson_builddir)
}

export def build [] {
	let make_cmd = state-default make_cmd 'ninja'
	let make_build_target = state-default make_build_target 'all'
	let meson_builddir = state-default meson_builddir (gen-build-path)

	^$make_cmd -C $meson_builddir $make_build_target
}


