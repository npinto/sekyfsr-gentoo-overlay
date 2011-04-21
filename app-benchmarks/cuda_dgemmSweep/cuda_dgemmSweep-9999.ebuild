# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git

DESCRIPTION="DGEMM-based GPU burn-in / stress test (in CUDA)"
HOMEPAGE="http://forums.nvidia.com/index.php?showtopic=86624"
EGIT_REPO_URI="https://github.com/npinto/cuda_dgemmSweep"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-util/nvidia-cuda-toolkit-3.2"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_compile() {
	emake all || die "emake all failed" 
}

src_install() {
	exeinto /usr/bin
	doexe cuda_dgemmSweep || die "doexe failed"
	doexe cuda_dgemmSweep_sm20 || die "doexe failed"
}
