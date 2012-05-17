#!/dev/null

_distribution_ubuntu_dependencies=(
	# mOSAIC custom packages
		mosaic-sun-jdk-7u1 #### missing
		mosaic-nodejs-0.6.15 #### missing
		mosaic-erlang-r15b01 #### missing
	# Ubuntu generic packages
		tar
		zip
		wget
		curl
	# Slitaz development packages
		perl
		python
		gcc
		g++
		binutils
		libtool
		autoconf
		automake
		make
		scons
		pkg-config
		jansson #### missing
		libxml2-dev
		uuid-dev
	# Slitaz miscellaneous packages
		git
)
