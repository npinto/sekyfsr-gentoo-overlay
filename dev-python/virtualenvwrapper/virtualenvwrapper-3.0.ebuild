# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils
inherit python

DESCRIPTION="virtualenvwrapper is a set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="http://www.doughellmann.com/projects/virtualenvwrapper http://pypi.python.org/pypi/virtualenvwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/virtualenv"
DEPEND="${DEPEND}
dev-python/setuptools
test? ( dev-python/tox )"


src_test() {
	testing() {
		PYTHON_MAJOR="$(python_get_version --major)"
		PYTHON_MINOR="$(python_get_version --minor)"
		cp ${FILESDIR}/tox.ini .
		tox -e py${PYTHON_MAJOR}${PYTHON_MINOR}
	}
	python_execute_function testing
}
