# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cgminer/cgminer-3.7.2.ebuild,v 1.2 2013/11/12 21:54:57 blueness Exp $

EAPI=5

inherit autotools flag-o-matic

DESCRIPTION="Scrypt based fork of cgminer"
HOMEPAGE="https://github.com/veox/sgminer"
SRC_URI="https://github.com/veox/sgminer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc hardened ncurses adl"

DEPEND="net-misc/curl
	dev-libs/jansson
	virtual/opencl
	adl? ( x11-libs/amd-adl-sdk )
	ncurses? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}"

src_prepare() {
	ln -s /usr/include/ADL/* ADL_SDK/
	eautoreconf
}

src_configure() {
	use hardened && append-cflags "-nopie"

	econf $(use_with ncurses curses) \
		$(use_enable adl)
	# sanitize directories (is this still needed?)
	sed -i 's~^\(\#define SGMINER_PREFIX \).*$~\1"'"${EPREFIX}/usr/lib/sgminer"'"~' configure
}

src_install() { # How about using some make install?
	dobin sgminer
	if use doc; then
		dodoc AUTHORS.md NEWS.md README.md 
		dodoc doc/API doc/GPU doc/KERNEL.md doc/MINING.md
	fi

	insinto /usr/lib/sgminer
	doins kernel/*.cl

# This is fixed in git master, reenable in 4.2.0
#	if use examples; then
#		docinto examples
#		dodoc api-example.php miner.php API.java api-example.c example.conf
#	fi
}
