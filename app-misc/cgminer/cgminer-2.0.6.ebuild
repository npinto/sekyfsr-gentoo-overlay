# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="CPU/GPU miner in c for bitcoin"
HOMEPAGE="https://bitcointalk.org/index.php?topic=28402.0"
SRC_URI="http://ck.kolivas.org/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="adl altivec opencl padlock sse2 sse2_4way sse4"
REQUIRED_USE='
	adl? ( opencl )
	altivec? ( ppc ppc64 )
	padlock? ( || ( amd64 x86 ) )
	sse2? ( || ( amd64 x86 ) )
	sse4? ( amd64 )
'

DEPEND='
	net-misc/curl
	sys-libs/ncurses
	>=dev-libs/jansson-2
	sse2? (
		>=dev-lang/yasm-1.0.1
	)
	sse4? (
		>=dev-lang/yasm-1.0.1
	)
	opencl? (
		|| (
			virtual/opencl-sdk
			app-admin/eselect-opencl
			dev-util/ati-stream-sdk
			dev-util/ati-stream-sdk-bin
			dev-util/amdstream
			dev-util/amd-app-sdk
			dev-util/amd-app-sdk-bin
			dev-util/nvidia-cuda-sdk[opencl]
			dev-util/intel-opencl-sdk
		)
	)
'
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	sys-apps/sed
	adl? (
		dev-util/amd-adl-sdk
	)
"

src_prepare() {
	sed -i 's/\(^\#define WANT_.*\(SSE\|PADLOCK\|ALTIVEC\)\)/\/\/ \1/' miner.h
	ln -s /usr/include/ADL/* ADL_SDK/
}

src_configure() {
	local CFLAGS="${CFLAGS}"
	if ! use altivec; then
		sed -i 's/-faltivec//g' configure
	else
		CFLAGS="${CFLAGS} -DWANT_ALTIVEC=1"
	fi
	use padlock && CFLAGS="${CFLAGS} -DWANT_VIA_PADLOCK=1"
	if use sse2; then
		if use amd64; then
			CFLAGS="${CFLAGS} -DWANT_X8664_SSE2=1"
		else
			CFLAGS="${CFLAGS} -DWANT_X8632_SSE2=1"
		fi
	fi
	use sse2_4way && CFLAGS="${CFLAGS} -DWANT_SSE2_4WAY=1"
	use sse4 && CFLAGS="${CFLAGS} -DWANT_X8664_SSE4=1"
	CFLAGS="${CFLAGS}" \
	econf \
		$(use_enable adl) \
		$(use_enable opencl)
	if use opencl; then
		# sanitize directories
		sed -i 's/^(\#define CGMINER_PREFIX ).*$/\1"'"${EPREFIX}/usr/share/cgminer"'"/' config.h
	fi
}

src_install() {
	dobin cgminer
	dodoc AUTHORS NEWS README
	if use opencl; then
		insinto /usr/share/cgminer
		doins *.cl
	fi
}
