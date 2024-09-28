export def extract [] {
	mut f = ''
	mut curfile = ''
	let workdir = ''
	let distfiles: list<string> = [] #get state

	mkdir $workdir
	for f in $distfiles {
		#curfile="${f#*>}"
		#curfile="${curfile##*/}"
		#cp ${XBPS_SRCDISTDIR}/${pkgname}-${version}/${curfile} "${wrksrc}/${curfile}"
	}
}
