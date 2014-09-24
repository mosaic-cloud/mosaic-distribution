#!/dev/null

_distribution_opensuse_dependencies=(
	# OpenSUSE core packages
		bash
		coreutils
		util-linux
	# OpenSUSE tools packages
		zip unzip
		tar cpio
		grep sed gawk
		findutils
		gzip bzip2
		which
	# OpenSUSE network packages
		wget
		curl
	# OpenSUSE miscellaneous packages
		git-core
		patch
		diffutils
	# OpenSUSE language packages
		python-base python #32bit
		perl-base perl #32bit
		java-1_7_0-openjdk-devel
	# OpenSUSE C/C++ packages
		gcc-32bit gcc
		gcc-c++-32bit gcc-c++
		binutils-devel-32bit binutils
	# OpenSUSE development packages
		make
		autoconf
		automake
		libtool-32bit libtool
	# OpenSUSE library packages
		glibc-devel-static-32bit
		libopenssl-devel-32bit
		zlib-devel-32bit
		ncurses-devel-32bit
		libuuid-devel-32bit
		libxml2-devel-32bit
)

if test "${pallur_local_os_packages_skip_installation:-false}" == true ; then
	echo "[ii] package installation disabled; skipping package installation!" >&2
elif test "${UID}" -ne 0 ; then
	echo "[ww] running without root priviledges; skipping package installation!" >&2
else
	zypper -n refresh
	# zypper -n --no-refresh update
	for _dependency in "${_distribution_opensuse_dependencies[@]}" ; do
		zypper -n --no-refresh install -- "${_dependency}"
	done
fi

if true ; then
	_local_os_packages+=( core )
	if ! test -e "${_tools}/pkg/core" ; then
		mkdir -- "${_tools}/pkg/core"
		mkdir -- "${_tools}/pkg/core/bin"
	fi
	for _dependency in "${_distribution_opensuse_dependencies[@]}" ; do
		rpm -q -l -q -- "${_dependency}" \
		| ( grep -E -e '^/(bin|usr/bin|usr/local/bin|opt/[^/]+/bin)/[^/]+$' || true ) \
		| while read _path ; do
			ln -s -f -t "${_tools}/pkg/core/bin" -- "${_path}"
		done
	done
fi

if ! test -e "${_tools}/pkg/java" ; then
	_local_os_packages+=( java )
	ln -s -f -T -- /usr/lib64/jvm/java-1.7.0-openjdk "${_tools}/pkg/java"
fi
