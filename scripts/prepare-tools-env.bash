#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


if test ! -e "${_tools}/.prepared" ; then
	
	echo "[ii] preparing tools..." >&2
	
	for _tools_folder in "${_tools}" "${_tools}/bin" "${_tools}/lib" "${_tools}/include" "${_tools}/pkg" ; do
		if test ! -e "${_tools_folder}" ; then
			mkdir -m 0700 -- "${_tools_folder}"
		fi
	done
	
	for _tools_folder in "${_tools}/pkg/miscellaneous" "${_tools}/pkg/miscellaneous/bin" ; do
		if test ! -e "${_tools_folder}" ; then
			mkdir -m 0700 -- "${_tools_folder}"
		fi
	done
	
	_local_os_packages=()
	
	case "${_local_os}" in
		
		( archlinux::rolling )
			
			echo "[ii] preparing \`archlinux\` environment..." >&2
			
			. "${_scripts}/prepare-tools-env-archlinux.bash"
			
			if test "${UID}" -eq 0 ; then
				
				pacman -Sy --noconfirm
				pacman -Su --noconfirm
				
				for _dependency in "${_distribution_archlinux_dependencies[@]}" ; do
					pacman -S --noconfirm --needed -- "${_dependency}"
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
				for _dependency in "${_distribution_archlinux_dependencies[@]}" ; do
					pacman -Q -l -q -- "${_dependency}" \
					| grep -E -e '^/(bin|usr/bin|usr/local/bin|opt/[^/]+/bin)/[^/]+$' \
					| while read _path ; do
						ln -s -f -t "${_tools}/pkg/core/bin" -- "${_path}"
					done
				done
			fi
			
			if ! test -e "${_tools}/pkg/java" ; then
				_local_os_packages+=( java )
				ln -s -f -T -- /usr/lib/jvm/java-7-openjdk "${_tools}/pkg/java"
			fi
		;;
		
		( unknown::* )
			echo "[ww] unknown local OS \`${_local_os}\`; proceeding!" >&2
			exit 1
		;;
		
		( * )
			echo "[ee] invalid local OS \`${_local_os}\`; aborting!" >&2
			exit 1
		;;
		
	esac
	
	for _package in "${_local_os_packages[@]}" ; do
		if test ! -e "${_tools}/pkg/${_package}/bin" ; then
			continue
		fi
		find -H "${_tools}/pkg/${_package}/bin" \
			-xtype f -executable \
			-exec ln -s -f -t "${_tools}/bin" {} \;
	done
	
	if test ! -e "${_tools}/bin/python" -a -e "${_tools}/bin/python2" ; then
		ln -s -f -T -- "${_tools}/bin/python2" "${_tools}/bin/python"
	fi
	
	touch "${_tools}/.prepared"
fi


exit 0
