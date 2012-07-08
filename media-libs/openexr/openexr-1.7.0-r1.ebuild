# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils libtool

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 -arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples static-libs"

RDEPEND="sys-libs/zlib
	>=media-libs/ilmbase-1.0.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "s:/var/tmp/:${T}:" \
		IlmImfTest/tmpDir.h || die # Fix path for testsuite

	epatch "${FILESDIR}"/${P}-gcc43.patch

	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable examples imfexamples)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}/usr/share/doc/${PF}/pdf" \
		examplesdir="${EPREFIX}/usr/share/doc/${PF}/examples" \
		install || die

	dodoc AUTHORS ChangeLog NEWS README

	if use examples; then
		dobin IlmImfExamples/imfexamples || die
	else
		rm -rf "${ED}"/usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -delete
}
