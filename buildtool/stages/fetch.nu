const SOURCEFORGE_SITE = "https://downloads.sourceforge.net/sourceforge"
const NONGNU_SITE = "https://download.savannah.nongnu.org/releases"
const UBUNTU_SITE = "http://archive.ubuntu.com/ubuntu/pool"
const XORG_SITE = "https://www.x.org/releases/individual"
const DEBIAN_SITE = "https://ftp.debian.org/debian/pool"
const GNOME_SITE = "https://download.gnome.org/sources"
const KERNEL_SITE = "https://www.kernel.org/pub/linux"
const CPAN_SITE = "https://www.cpan.org/modules/by-module"
const PYPI_SITE = "https://files.pythonhosted.org/packages/source"
const MOZILLA_SITE = "https://ftp.mozilla.org/pub"
const GNU_SITE = "https://ftp.gnu.org/gnu"
const FREEDESKTOP_SITE = "https://www.freedesktop.org/software"
const KDE_SITE = "https://download.kde.org/stable"
const VIDEOLAN_SITE = "https://download.videolan.org/pub/videolan"

def main [
    pkgname: string
    cross_target: string | null
] {
    setup_pkg $pkgname $cross_target

    # TODO: Add state handling here

    #run pre-fetch hooks
    #if template defines pre_fetch(), use it

    #if templ defines do_fetch, otherwise use our hook

		let workdir = ''
    try {
			cd $workdir
		} catch {
			error make {msg: $'cannot access workdir: ($workdir)'}
		}

    #if templ defines post_fetch, use it
    #run post-fetch hooks
}
