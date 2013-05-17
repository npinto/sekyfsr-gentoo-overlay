# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )

inherit distutils-r1 flag-o-matic

MY_PN="Cython"
MY_P="${MY_PN}-${PV/_/}"

DESCRIPTION="A Python to C compiler"
HOMEPAGE="http://www.cython.org/ http://pypi.python.org/pypi/Cython"
SRC_URI="http://www.cython.org/release/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc test"

# Note: update numpy dep when it is fixed for py3.3.
RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? (
		>=dev-python/numpy-1.6.1-r1[$(python_gen_usedep 'python2*' 'python3_[12]' )]
	)"

S="${WORKDIR}/${MY_PN}-${PV%_*}"

python_compile() {
	if [[ ${EPYTHON} == python2* ]]; then
		local CFLAGS CXXFLAGS
		append-flags -fno-strict-aliasing
	fi

	# Python gets confused when it is in sys.path before build.
	local PYTHONPATH
	export PYTHONPATH

	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" runtests.py -vv --work-dir "${BUILD_DIR}"/tests \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.txt ToDo.txt USAGE.txt )
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
