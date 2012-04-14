# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython *-pypy-*"

inherit eutils fortran-2 distutils flag-o-matic toolchain-funcs git-2

DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="http://www.scipy.org/ http://pypi.python.org/pypi/scipy"
SRC_URI=""
EGIT_REPO_URI="https://github.com/scipy/scipy.git"

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="test umfpack"
KEYWORDS=""

CDEPEND="dev-python/numpy
	sci-libs/arpack
	virtual/cblas
	virtual/lapack
	umfpack? ( sci-libs/umfpack )"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	test? ( dev-python/nose )
	umfpack? ( dev-lang/swig )"

RDEPEND="virtual/fortran
	${CDEPEND}
	dev-python/imaging"

DOCS="THANKS.txt LATEST.txt TOCHANGE.txt"

pkg_setup() {
	fortran-2_pkg_setup
	# scipy automatically detects libraries by default
	export {FFTW,FFTW3,UMFPACK}=None
	use umfpack && unset UMFPACK
	# the missing symbols are in -lpythonX.Y, but since the version can
	# differ, we just introduce the same scaryness as on Linux/ELF
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared
	[[ -z ${FC}  ]] && export FC="$(tc-getFC)"
	# hack to force F77 to be FC until bug #278772 is fixed
	[[ -z ${F77} ]] && export F77="$(tc-getFC)"
	export F90="${FC}"
	export SCIPY_FCONFIG="config_fc --noopt --noarch"
	append-fflags -fPIC
	python_pkg_setup
}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	local libdir="${EPREFIX}"/usr/$(get_libdir)
	cat >> site.cfg <<-EOF
		[blas]
		include_dirs = $(pkg-config --cflags-only-I \
			cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
		library_dirs = $(pkg-config --libs-only-L \
			cblas blas | sed -e 's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):${libdir}
		blas_libs = $(pkg-config --libs-only-l \
			cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		[lapack]
		library_dirs = $(pkg-config --libs-only-L \
			lapack | sed -e 's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):${libdir}
		lapack_libs = $(pkg-config --libs-only-l \
			lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
	EOF
}

src_compile() {
	distutils_src_compile ${SCIPY_FCONFIG}
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install \
			--home="${S}/test-${PYTHON_ABI}" --no-compile ${SCIPY_FCONFIG} \
			|| die "install test failed"
		pushd "${S}/test-${PYTHON_ABI}/"lib*/python > /dev/null
		PYTHONPATH=. "$(PYTHON)" -c "import scipy; scipy.test('full')" \
			2>&1 | tee test.log
		grep -q ^ERROR test.log && die "test failed"
		popd > /dev/null
		rm -fr test-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install ${SCIPY_FCONFIG}
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "You might want to set the variable SCIPY_PIL_IMAGE_VIEWER"
	elog "to your prefered image viewer if you don't like the default one. Ex:"
	elog "\t echo \"export SCIPY_PIL_IMAGE_VIEWER=display\" >> ~/.bashrc"
}
