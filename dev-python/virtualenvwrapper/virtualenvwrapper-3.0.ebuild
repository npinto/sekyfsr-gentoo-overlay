# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils
inherit distutils
inherit python

DESCRIPTION="virtualenvwrapper is a set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="http://www.doughellmann.com/projects/virtualenvwrapper http://pypi.python.org/pypi/virtualenvwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/virtualenv"
DEPEND="${DEPEND}
	dev-python/setuptools
	test? ( dev-python/tox )"

src_prepare() {
	epatch ${FILESDIR}/${P}-pathfix.patch

	cp -r ${FILESDIR}/testpackage ./tests/

	cp ${FILESDIR}/tox.ini .

	for f in tests/test_*sh; do
		chmod +x ${f};
	done;
}

src_test() {

	testing() {
		PYTHON_MAJOR="$(python_get_version --major)"
		PYTHON_MINOR="$(python_get_version --minor)"
		export TMPDIR=${T}
		tox -e py${PYTHON_MAJOR}${PYTHON_MINOR}
	}

	python_execute_function testing
}

src_install() {

	# Bug #404103
	touch __init__.py
	installation() {
		insinto $(python_get_sitedir)/${PN}
		doins ${files} __init__.py
	}
	python_execute_function installation

	distutils_src_install
}
