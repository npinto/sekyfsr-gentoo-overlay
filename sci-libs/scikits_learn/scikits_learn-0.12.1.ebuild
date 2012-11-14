# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils multilib flag-o-matic

MYPN="${PN/scikits_/scikit-}"

DESCRIPTION="Python modules for machine learning and data mining"
HOMEPAGE="http://scikit-learn.org"
SRC_URI="mirror://sourceforge/${MYPN}/${MYPN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

CDEPEND="sci-libs/scipy
	>=sci-libs/libsvm-2.91"
RDEPEND="${CDEPEND}
	sci-libs/scikits
	dev-python/matplotlib"
DEPEND="${CDEPEND}
	dev-python/cython
	dev-python/setuptools
	doc? ( dev-python/sphinx dev-python/matplotlib )"

S="${WORKDIR}/${MYPN}-${PV}"

src_prepare() {
	#epatch "${FILESDIR}"/0.10-atlas.patch
	# use stock libsvm
	cat <<-EOF >> site.cfg
		[libsvm]
		libraries=svm
		library_dirs=${EPREFIX}/usr/$(get_libdir)
		include_dirs=${EPREFIX}/usr/include/
	EOF
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared
}

src_compile() {
	distutils_src_compile
	if use doc; then
		cd "${S}/doc"
		local d=$(ls -d "${S}"/build-$(PYTHON -f --ABI)/lib*)
		ln -s "${S}"/sklearn/datasets/{data,descr,images} \
			"${d}"/sklearn/datasets
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${S}/build-$(PYTHON -f --ABI)" \
			PYTHONPATH="${d}" \
			emake html
		rm -r "${d}"/sklearn/datasets/{data,desr,images}
	fi
}

src_install() {
	find "${S}" -name \*LICENSE.txt -delete

	# Monkey patch workaround for Bug #413023 
	mkdir ${S}/build-$(PYTHON -f --ABI)/scripts.linux-x86_64-$(PYTHON -f --ABI)

	distutils_src_install
	remove_scikits() {
		rm -f "${ED}"$(python_get_sitedir)/scikits/__init__.py || die
	}
	python_execute_function -q remove_scikits
	insinto /usr/share/doc/${PF}
	use doc && dohtml -r doc/_build/html
	use examples && doins -r examples
}
