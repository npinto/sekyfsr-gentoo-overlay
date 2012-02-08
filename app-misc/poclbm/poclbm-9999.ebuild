# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git-2 python

DESCRIPTION="An Python openCL bitcoin miner"
HOMEPAGE="https://github.com/m0mchil/poclbm"
EGIT_REPO_URI="git://github.com/m0mchil/poclbm.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyopencl"

TARGETDIR=/usr/libexec/${PN}

src_prepare() {
	      rm LICENSE || die "license remove failed"
	      fperms 755 poclbm.py || die "fperms failed"
	      sed -i "s:phatk.cl:${TARGETDIR}\/phatk.cl:" BitcoinMiner.py || die "sed failed"
}

src_install() {
	      insinto ${TARGETDIR} 
	      insopts -m0755
	      doins * || die "doins failed"
	      dosym ${TARGETDIR}/poclbm.py /bin/poclbm || die "dosym failed"
}
