# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc examples"
RUBY_FAKEGEM_EXTRADOC="README.txt TODO History.txt"
RUBY_FAKEGEM_EXTRAINSTALL=""

inherit ruby-fakegem

DESCRIPTION="Ruby implementation for Protocol Buffers."
HOMEPAGE="http://code.google.com/p/ruby-protobuf"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE=""

