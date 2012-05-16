#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

case "${_distribution_local_os}" in
	
	( mos )
		
		_mos_dependencies=(
			# mOSAIC custom packages
				mosaic-sun-jdk-7u1
				mosaic-nodejs-0.6.15
				mosaic-erlang-r15b01
				coreutils-operations-8.12.1
			# Slitaz generic packages
				coreutils
				coreutils-character
				coreutils-command
				coreutils-conditions
				coreutils-context-system
				coreutils-context-user
				coreutils-context-working
				coreutils-directory
				coreutils-file-attributes
				coreutils-file-format
				coreutils-file-output-full
				coreutils-file-output-part
				coreutils-file-sort
				coreutils-file-special
				coreutils-file-summarize
				coreutils-line
				coreutils-numeric
				coreutils-path
				coreutils-redirection
				findutils
				grep
				sed
				gawk
				tar
				zip
				wget
				curl
			# Slitaz development packages
				perl
				python
				gcc
				libtool
				autoconf
				automake
				pkg-config
				util-linux-ng-uuid-dev
			# Slitaz miscellaneous packages
				git
		)
		
		for _mos_dependency in "${_mos_dependencies[@]}" ; do
			tazpkg get-install "${_mos_dependency}"
		done
		
		if test ! -e "${_tools}/pkg/erlang" ; then
			ln -s -T -- /opt/mosaic-erlang-r15b01/lib/erlang "${_tools}/pkg/erlang"
		fi
		
		if test ! -e "${_tools}/bin/python2" ; then
			ln -s -T -- /usr/bin/python2.7 "${_tools}/bin/python2"
		fi
		
	;;
	
	( unknown )
	;;
	
	( * )
		echo "[ee] invalid local OS \`${_distribution_local_os}\`; aborting!" >&2
		exit 1
	;;
esac

"${_git_bin}" submodule update --quiet --init --recursive
"${_git_bin}" submodule foreach --quiet --recursive 'chmod -R +w . && git reset -q --hard HEAD && git clean -q -f -d -x'

if test ! -e "${_repositories}/mosaic-java-platform/.lib" ; then
	ln -s -T -- "${_tools}/lib" "${_repositories}/mosaic-java-platform/.lib"
fi

if test ! -e "${_repositories}/mosaic-examples-realtime-feeds/.lib" ; then
	ln -s -T -- "${_tools}/lib" "${_repositories}/mosaic-examples-realtime-feeds/.lib"
fi

exit 0
