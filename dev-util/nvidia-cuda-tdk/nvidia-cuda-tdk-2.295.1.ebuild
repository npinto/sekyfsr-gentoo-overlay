# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="NVIDIA Tesla Deployment Kit"
HOMEPAGE="http://developer.nvidia.com/tesla-deployment-kit"

SRC_URI=http://developer.download.nvidia.com/assets/cuda/files/CUDADownloads/NVML/tdk_${PV}_linux.tar.gz
LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc +examples"

RDEPEND="
>=dev-util/nvidia-cuda-toolkit-4.1
examples? ( >=x11-drivers/nvidia-drivers-260.19.21 )
media-libs/freeglut
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

RESTRICT="binchecks"

src_unpack() {
	unpack ${A}
	cd ${S}
	tar xvf ${A%.*}
}

src_compile() {
	cd "${S}/tdk_${PV}/"

	if use examples; then
		cd example
		emake || die
	fi
}

src_install() {
	cd "${S}/tdk_${PV}/"

	if ! use doc; then
		rm -rf *.txt doc
	fi

	if ! use examples; then
		rm -rf example
	fi

	for f in $(find .); do
		local t="$(dirname ${f})"
		if [[ "${t/obj\/}" != "${t}" || "${t##*.}" == "a" ]]; then
			continue
		fi

		if [[ ! -d "${f}" ]]; then
			if [[ -x "${f}" ]]; then
				exeinto "/opt/cuda/tdk/${t}"
				doexe "${f}"
			else
				insinto "/opt/cuda/tdk/${t}"
				doins "${f}"
			fi
		fi
	done
}
