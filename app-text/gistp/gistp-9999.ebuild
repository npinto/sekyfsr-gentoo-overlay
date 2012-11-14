# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/miyagawa/gistp.git"

inherit perl-app git-2

DESCRIPTION="Yet another gist command line tool (like gisty)"
HOMEPAGE="https://github.com/miyagawa/gistp"
SRC_URI=""

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
RDEPEND="
	dev-perl/WWW-Mechanize
	virtual/perl-Getopt-Long
	dev-perl/File-Slurp"
