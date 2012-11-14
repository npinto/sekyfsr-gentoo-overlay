# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/swdyh/gisty.git"
	my_src_uri=""
	git_eclass="git-2"
else
	my_src_uri="http://github.com/swdyh/gisty/tarball/${PV} -> ${P}.tar.gz"
	git_eclass="vcs-snapshot"
fi

USE_RUBY="ruby18"

inherit ${git_eclass} ruby-fakegem

DESCRIPTION="Yet another command line client for gist"
HOMEPAGE="https://github.com/swdyh/gisty"
SRC_URI="${my_src_uri}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

ruby_add_bdepend dev-ruby/rake
ruby_add_rdepend dev-ruby/fakeweb
ruby_add_rdepend dev-ruby/json
ruby_add_rdepend dev-ruby/rr

all_ruby_unpack() {
	${git_eclass}_src_unpack
}
