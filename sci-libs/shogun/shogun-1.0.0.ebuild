# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib
inherit versionator
inherit python

EAPI="2"

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Shogun is a large scale machine learning toolbox and focus on large scale kernel methods such as Support Vector Machines (SVM)"
HOMEPAGE="http://shogun-toolbox.org"
#SRC_URI="http://shogun-toolbox.org/archives/shogun/releases/${MY_PV}/sources/${P}.tar.bz2"
SRC_URI="ftp://shogun-toolbox.org/shogun/releases/${MY_PV}/sources/${P}.tar.bz2"
#SRC_URI="https://github.com/shogun-toolbox/shogun/tarball/shogun_1.0.0"
#SRC_URI=ftp://shogun-toolbox.org/shogun/releases/1.0/sources/shogun-1.0.0.tar.bz2

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mono lua java R ruby octave python"

DEPEND="
sci-libs/gsl
sci-mathematics/glpk
mono? ( dev-lang/mono )
lua? ( dev-lang/lua )
R? ( dev-lang/R )
ruby? ( dev-lang/ruby )
octave? ( sci-mathematics/octave )
python? ( dev-lang/python
         =dev-python/numpy-1* )"
RDEPEND=""

PYTHON_DEPEND="python? 2:2.6"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	unpack ${A}
	cd ${WORKDIR}/${P}
	epatch ${FILESDIR}/${P}-disable-ldconfig.patch
}

src_configure() {
	cd ${WORKDIR}/${P}/src || die

	interfaces=""
	if use mono ; then
		interfaces="${interfaces}csharp_modular,"
	fi
	if use lua ; then
		interfaces="${interfaces}lua_modular,"
	fi
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

	confopts=""
	confopts="${confopts} --interfaces=${interfaces}"
	confopts="${confopts} --prefix=${EPREFIX}/usr"
	confopts="${confopts} --mandir=${EPREFIX}/usr/share/man"
	confopts="${confopts} --datadir=${EPREFIX}/usr/share"
	confopts="${confopts} --libdir=${EPREFIX}/usr/$(get_libdir)"
	confopts="${confopts} --incdir=${EPREFIX}/usr/include"

	# -------------------------------------------------------
	# Fix MPI linking issues,
	# see https://github.com/shogun-toolbox/shogun/issues/323
	#confopts="${confopts} --ldflags='-lmpi -lmpi_cxx'"

	# -------------------------------------------------------
	# Fix BLAS related problem with arpack
	# (workaround for cblas_dsymv bug)
	# see http://comments.gmane.org/gmane.comp.ai.machine-learning.shogun/2319
	confopts="${confopts} --disable-arpack"

	# -------------------------------------------------------
	# FIX: XXX
	confopts="${confopts} --disable-hdf5"
	# -------------------------------------------------------

	./configure ${confopts} || die

}

src_compile() {
	cd ${WORKDIR}/${P}/src || die
	emake || die
}

src_install() {
	cd ${WORKDIR}/${P}/src || die
	emake DESTDIR="${D}" install || die
}

