# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit distutils subversion

DESCRIPTION="Tool for creating Gentoo ebuilds for Python packages by querying PyPI (The Cheese Shop)"
HOMEPAGE="http://tools.assembla.com/g-pypi/"
ESVN_REPO_URI="http://g-pypi.googlecode.com/svn/trunk/"
LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND="dev-python/pygments
dev-python/setuptools
dev-python/cheetah
dev-python/yolk
dev-pythonpython/configobj"

src_install() {
	distutils_src_install

	insinto /usr/lib/python${PYTHON_ABI}/site-packages/g_pypi/
	doins g_pypi/ebuild.tmpl || die "doins failed"
}
