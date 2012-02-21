# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2405
INTEL_DPV=2011_sp1_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse mkl ipp tbb"

DEPEND="~dev-libs/intel-common-${PV}[compiler]"
RDEPEND="${DEPEND}
	eclipse? ( dev-util/eclipse-sdk )"

QA_PREBUILT="
	${INTEL_SDP_DIR}/bin/*/*
	${INTEL_SDP_DIR}/compiler/lib/*/*
	${INTEL_SDP_DIR}/mpirt/bin/*/*
	${INTEL_SDP_DIR}/mpirt/lib/*/*
	mkl? ( ${INTEL_SDP_DIR}/mkl/bin/*/* ${INTEL_SDP_DIR}/mkl/lib/*/*
	ipp? ( ${INTEL_SDP_DIR}/ipp/bin/*/* ${INTEL_SDP_DIR}/ipp/lib/*/*
	tbb? ( ${INTEL_SDP_DIR}/tbb/bin/*/* ${INTEL_SDP_DIR}/tbb/lib/*/*
	"
QA_PRESTRIPPED="${INTEL_SDP_DIR}/compiler/lib/*/.*libFNP.so"

INTEL_BIN_RPMS="compilerproc compilerproc-devel"
INTEL_DAT_RPMS="compilerproc-common"
INTEL_BIN_RPMS="compilerproc"
#INTEL_BIN_RPMS=""
#INTEL_DAT_RPMS=""

pkg_setup() {
	INTEL_EXTRA_BIN_RPMS=""
	if use mkl; then
		INTEL_EXTRA_BIN_RPMS="${INTEL_EXTRA_BIN_RPMS} intel-mkl-sp1-${INTEL_PV4}-10.3-7 intel-mkl-sp1-devel-${INTEL_PV4}-10.3-7"
		INTEL_EXTRA_DAT_RPMS="${INTEL_EXTRA_DAT_RPMS} intel-mkl-sp1-common-${INTEL_PV4}-10.3-7"
	fi
	if use ipp; then
		INTEL_EXTRA_BIN_RPMS="${INTEL_EXTRA_BIN_RPMS} intel-ipp-sp1-${INTEL_PV4}-7.0-5 intel-ipp-sp1-devel-${INTEL_PV4}-7.0-5"
		INTEL_EXTRA_DAT_RPMS="${INTEL_EXTRA_DAT_RPMS} intel-ipp-sp1-common-${INTEL_PV4}-7.0-5"
	fi
	if use tbb; then
		INTEL_EXTRA_DAT_RPMS="${INTEL_EXTRA_DAT_RPMS} intel-tbb-sp1-${INTEL_PV4}-4.0-1 intel-tbb-sp1-devel-${INTEL_PV4}-4.0-1"
	fi

	intel-sdp_pkg_setup
}
