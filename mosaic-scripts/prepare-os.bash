#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test -e "${_tools}/.prepared" ; then
	exit 0
fi

echo "[ii] preparing environment..." >&2

for _tools_folder in "${_tools}" "${_tools}/bin" "${_tools}/pkg" ; do
	if test ! -e "${_tools_folder}" ; then
		mkdir -- "${_tools_folder}"
	fi
done

_local_os_packages=()

case "${_local_os}" in
	
	( archlinux::rolling | archlinux::unknown )
		
		echo "[ii] preparing \`archlinux\` environment..." >&2
		
		. "${_workbench}/mosaic-scripts/prepare-os-archlinux.bash"
	;;
	
	( opensuse::13.1 | opensuse::unknown )
		
		echo "[ii] preparing \`opensuse\` environment..." >&2
		
		. "${_workbench}/mosaic-scripts/prepare-os-opensuse.bash"
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
	if test ! -L "${_tools}/pkg/${_package}" ; then
		chmod -R a=rX -- "${_tools}/pkg/${_package}"
	fi
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

exit 0
