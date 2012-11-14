# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/mattikus/pygist.git"
	SRC_URI=""
	git_eclass="git-2"
else
	SRC_URI="http://github.com/mattikus/pygist/tarball/v${PV} -> ${P}.tar.gz"
	git_eclass="vcs-snapshot"
fi

PYTHON_DEPEND="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.*"

inherit ${git_eclass} python

DESCRIPTION="Python command line client for Github Gist"
HOMEPAGE="https://github.com/mattikus/pygist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="clipboard git"

DEPEND=""
RDEPEND="
	clipboard? ( x11-misc/xclip )
	git? ( dev-vcs/git )"

src_install() {
	exeinto /usr/bin
	installation() {
		newexe ${PN}.py ${PN}-${PYTHON_ABI}
		python_convert_shebangs ${PYTHON_ABI} "${ED}"/usr/bin/${PN}-${PYTHON_ABI}
	}
	python_execute_function installation
	python_generate_wrapper_scripts "${ED}"/usr/bin/${PN}
}
