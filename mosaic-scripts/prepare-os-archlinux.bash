#!/dev/null

_distribution_archlinux_dependencies=(
	# Archlinux tools packages
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
		which
	# Archlinux network packages
		wget
		curl
	# Archlinux language packages
		jdk7-openjdk
		python2
		perl
		gcc
	# Archlinux development packages
		git
		binutils
		libtool
		autoconf
		automake
		pkg-config
		make
		diffutils
	# Archlinux library packages
		libxml2
		ncurses
)

if test "${pallur_local_os_packages_skip_installation:-false}" == true ; then
	echo "[ii] package installation disabled; skipping package installation!" >&2
elif test "${UID}" -ne 0 ; then
	echo "[ww] running without root priviledges; skipping package installation!" >&2
else
	pacman -Sy --noconfirm
	# pacman -Su --noconfirm
	for _dependency in "${_distribution_archlinux_dependencies[@]}" ; do
		pacman -S --noconfirm --needed -- "${_dependency}"
	done
fi

if true ; then
	_local_os_packages+=( core )
	if ! test -e "${_tools}/pkg/core" ; then
		mkdir -- "${_tools}/pkg/core"
		mkdir -- "${_tools}/pkg/core/bin"
	fi
	for _dependency in "${_distribution_archlinux_dependencies[@]}" ; do
		pacman -Q -l -q -- "${_dependency}" \
		| ( grep -E -e '^/(bin|usr/bin|usr/local/bin|opt/[^/]+/bin)/[^/]+$' || true ) \
		| while read _path ; do
			ln -s -f -t "${_tools}/pkg/core/bin" -- "${_path}"
		done
	done
fi

if ! test -e "${_tools}/pkg/java" ; then
	_local_os_packages+=( java )
	ln -s -f -T -- /usr/lib/jvm/java-7-openjdk "${_tools}/pkg/java"
fi
