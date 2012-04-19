# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=subversion
	ESVN_REPO_URI="http://g-pypi.googlecode.com/svn/trunk/"
fi

inherit distutils ${SCM}

DESCRIPTION="Create Gentoo ebuilds for Python packages by querying The Python Package Index (PyPI)"
HOMEPAGE="http://tools.assembla.com/g-pypi/"

if [ "${PV%9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://pypi.python.org/packages/source/g/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose )"
RDEPEND="dev-python/setuptools
	dev-python/pygments
	dev-python/cheetah
	app-portage/gentoolkit
	dev-python/configobj
	dev-python/yolk"

src_install() {
	distutils_src_install

	insinto /usr/lib/python${PYTHON_ABI}/site-packages/g_pypi/
	doins g_pypi/ebuild.tmpl || die "doins failed"
}

src_test() {
	PYTHONPATH=. "${python}" setup.py nosetests || die "tests failed"
}
