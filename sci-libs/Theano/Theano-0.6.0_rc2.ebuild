# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Optimizing compiler for evaluating mathematical expressions on CPUs and GPUs"
HOMEPAGE="https://github.com/Theano/Theano http://pypi.python.org/pypi/Theano"
LICENSE="BSD"

MY_P=${P/_/}

if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=git-2
	EGIT_REPO_URI="git://github.com/Theano/${PN}.git"
fi

inherit distutils ${SCM}

if [ "${PV%9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
IUSE=""

RDEPEND="
	dev-python/setuptools
	dev-python/numpy
	sci-libs/scipy
	"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
