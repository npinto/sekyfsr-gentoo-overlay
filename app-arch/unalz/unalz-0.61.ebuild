# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils;

DESCRIPTION="Uncompress alz files"
HOMEPAGE="http://www.kipple.pe.kr/win/unalz/"
SRC_URI="http://www.kipple.pe.kr/win/unalz/${PN}-${PV}.tgz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="iconv unicode"
RESTRICT="nomirror"

DEPEND="iconv? ( virtual/libiconv )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack "${A}" || die "unpack failed"
	epatch "$FILESDIR/${P}-linux.patch" || die "epatch failed"
}

src_compile() {
	if use iconv ; then
		if use sparc-fbsd || use x86-fbsd ; then
			if use unicode ; then
				target_system="posix-utf8"
			else
				target_system="posix"
			fi
		else
			if use unicode ; then
				target_system="linux-utf8"
			else
				target_system="linux"
			fi
		fi
	else
		target_system="posix-noiconv"
	fi

	emake $target_system || die "emake ${target_system} failed"
}

src_install() {
	# `make install' copies 'unalz' file to hard coded /usr/local/bin.
	dobin unalz || die "dobin failed"
}
