# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A GPU memory test utility for NVIDIA and AMD GPUs using well
established patterns from memtest86/memtest86+ as well as additional stress
tests. The tests are designed to find hardware and soft errors. The code is
written in CUDA and OpenCL."
HOMEPAGE="http://sourceforge.net/projects/cudagpumemtest/"
SRC_URI="mirror://sourceforge/cudagpumemtest/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-util/nvidia-cuda-toolkit-3.2"
RDEPEND="${DEPEND}"

src_compile() {
	emake || die "emake failed" 
	emake cuda_memtest_sm10 || die "emake cudamemtest_sm10 failed" 
	emake cuda_memtest_sm20 || die "emake cudamemtest_sm20 failed" 
}

src_install() {
	exeinto /usr/bin
	doexe cuda_memtest || die "doexe failed"
	doexe cuda_memtest_sm10 || die "doexe failed"
	doexe cuda_memtest_sm20 || die "doexe failed"
}
