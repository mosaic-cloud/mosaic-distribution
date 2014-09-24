#!/dev/null

_distribution_opensuse_dependencies=(
	# OpenSUSE tools packages
		coreutils
		util-linux
		zip
		unzip
		cpio
		tar
		bash
		grep
		sed
		findutils
		which
		gawk
		gzip
		bzip2
		patch
	# OpenSUSE network packages
		wget
		curl
	# OpenSUSE language packages
		java-1_7_0-openjdk-devel
		python-base python
		perl-base perl
		gcc-32bit gcc
		gcc-c++-32bit gcc-c++
	# OpenSUSE development packages
		git-core
		binutils
		libtool
		autoconf
		automake
		pkg-config
		make
		diffutils
	# OpenSUSE library packages
		glibc-devel-static
		glibc-devel-static-32bit
		ncurses-devel-32bit
		libxml2-devel-32bit
)

if test "${UID}" -eq 0 ; then
	
	zypper -n refresh
	# zypper -n --no-refresh update
	
	for _dependency in "${_distribution_opensuse_dependencies[@]}" ; do
		zypper -n --no-refresh install -- "${_dependency}"
	done
	
else
	echo "[ww] running without root priviledges; skipping!" >&2
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
