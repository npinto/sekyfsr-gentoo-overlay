# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyflann/pyflann-1.8.4.ebuild,v 1.3 2013/09/05 18:47:18 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1
inherit cmake-utils

DESCRIPTION="Python bindings for FLANN artificial neural network library"
HOMEPAGE="http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN/"
SRC_URI="http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-${PV}-src.zip
	test? ( http://dev.gentoo.org/~bicatali/distfiles/flann-${PV}-testdata.tar.xz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~sci-libs/flann-${PV}"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/flann-${PV}-src
#S="${WORKDIR}/flann-${PV}-src/src/python"

PATCHES=(
	"${FILESDIR}"/PR_124__1-70ac5c7296da9eb5ccb151e0ebcb6db7600964ff.patch
	"${FILESDIR}"/PR_124__2-b822306e59df73268fefac3ae888e6b7639df9ff.patch
	"${FILESDIR}"/PR_124__3-25ae6328a3af0fbb0cf3a63e825eaa3e72934764.patch
)

python_prepare_all() {
	cd "${S}/src/python"
	sed -e "s/@FLANN_VERSION@/${PV}/" \
		-e '/package_d/d' \
		-e "s/,.*'pyflann.lib'//" \
		setup.py.tpl >> setup.py

	use test && ln -s "${WORKDIR}"/testdata/* "${WORKDIR}"/flann-${PV}-src/test/
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${WORKDIR}"/flann-${PV}-src/test/
	local t
	#for t in test*.py; do
	# test_autotune buggy
	for t in test_{nn,nn_index,index_save,clustering}.py; do
		einfo "Running ${t}"
		PYTHONPATH="${BUILD_DIR}/lib" ${EPYTHON} ${t} || die
	done
}
