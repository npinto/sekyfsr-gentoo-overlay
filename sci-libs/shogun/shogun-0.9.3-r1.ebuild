# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib
inherit versionator
inherit python

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Shogun is a large scale machine learning toolbox and focus on large scale kernel methods such as Support Vector Machines (SVM)"
HOMEPAGE="http://shogun-toolbox.org"
SRC_URI="ftp://shogun-toolbox.org/shogun/releases/${MY_PV}/sources/${P}.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mono lua java R ruby octave python glpk"

DEPEND="
sci-libs/gsl
sci-mathematics/glpk
R? ( dev-lang/R )
ruby? ( dev-lang/ruby )
octave? ( sci-mathematics/octave )
python? ( dev-lang/python
         =dev-python/numpy-1* )
glpk? ( sci-mathematics/glpk )
"
RDEPEND=""

PYTHON_DEPEND="python? 2:2.6"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	cd ${WORKDIR}/${P}
	epatch ${FILESDIR}/${PN}-1.0.0-disable-ldconfig.patch
	epatch ${FILESDIR}/${P}-fix-swig-version.patch
}

src_configure() {
	cd ${WORKDIR}/${P}/src || die

	interfaces="libshogun,"
	if use R ; then
		interfaces="${interfaces}r_modular,"
	fi
	if use ruby ; then
		interfaces="${interfaces}ruby_modular,"
	fi
	if use octave ; then
		interfaces="${interfaces}octave_modular,"
	fi
	if use python ; then
		interfaces="${interfaces}python_modular,"
	fi
	interfaces="${interfaces%?}"
	echo ${interfaces}

	libdir=${EPREFIX}/usr/$(get_libdir)
	pydir=$(echo $(python_get_sitedir) | sed -e "s;${libdir}/;;g")

	./configure \
	--interfaces=${interfaces} \
	--prefix=${EPREFIX}/usr \
	--mandir=${EPREFIX}/usr/share/man \
	--datadir=${EPREFIX}/usr/share \
	--libdir=${libdir} \
	--pydir=${pydir} \
	--disable-hdf5
}

src_compile() {
	cd ${WORKDIR}/${P}/src || die
	emake || die
}

src_install() {
	cd ${WORKDIR}/${P}/src || die
	emake DESTDIR="${D}" install || die
}
