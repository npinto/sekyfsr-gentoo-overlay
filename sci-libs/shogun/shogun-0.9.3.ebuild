# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator
EAPI="2"

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Shogun is a large scale machine learning toolbox and focus on large scale kernel methods such as Support Vector Machines (SVM)"
HOMEPAGE="http://shogun-toolbox.org"
SRC_URI="http://shogun-toolbox.org/archives/shogun/releases/${MY_PV}/sources/${P}.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mono lua java R ruby octave python glpk"

DEPEND="
sci-libs/gsl
R? ( dev-lang/R )
ruby? ( dev-lang/ruby )
octave? ( sci-mathematics/octave )
python? ( dev-lang/python
         =dev-python/numpy-1* )
glpk? ( sci-mathematics/glpk )
"
RDEPEND=""

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

	./configure --prefix=/usr \
				--mandir=/usr/share/man \
				--datadir=/usr/share \
				--libdir=/usr/lib64 \
				--interfaces=${interfaces}
}

src_compile() {
	cd ${WORKDIR}/${P}/src || die
	emake || die "make failed. If the error is related to unfound CBLAS function, eselect sci-libs/gsl implementation of cblas."
}

src_install() {
	cd ${WORKDIR}/${P}/src || die
	emake DESTDIR="${D}" install || die "make install failed."
}
