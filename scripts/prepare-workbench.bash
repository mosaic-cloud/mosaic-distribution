#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


if test ! -e "${_temporary}" ; then
	if test -L "${_temporary}" ; then
		_temporary_store="$( readlink -- "${_temporary}" )"
	else
		_temporary_store="${_temporary}"
	fi
	if test ! -e "${_temporary_store}" ; then
		mkdir -- "${_temporary_store}"
	fi
fi


if test ! -e "${_outputs}" ; then
	if test -L "${_outputs}" ; then
		_outputs_store="$( readlink -- "${_outputs}" )"
	else
		_outputs_store="${_temporary}/$( basename -- "${_workbench}" )--$( readlink -m -- "${_outputs}" | tr -d '\n' | md5sum -t | tr -d ' \n-' )"
		ln -s -T -- "${_outputs_store}" "${_outputs}"
	fi
	if test ! -e "${_outputs_store}" ; then
		mkdir -- "${_outputs_store}"
	fi
fi


exit 0
