# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/gmarik/gist.sh.git"

inherit git-2

DESCRIPTION="Bash shell client for Github Gist service"
HOMEPAGE="https://github.com/gmarik/gist.sh"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="clipboard git"

DEPEND=""
RDEPEND="net-misc/curl
	clipboard? ( x11-misc/xclip )
	git? ( dev-vcs/git )"

src_install() {
	exeinto /usr/bin
	doexe gist.sh
}
