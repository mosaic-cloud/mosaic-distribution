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
if test ! -e "${_workbench}/.temporary" ; then
	ln -s -T -- "${_temporary}" "${_workbench}/.temporary"
fi

if test ! -e "${_HOME}" ; then
	mkdir -- "${_HOME}"
fi
if test ! -e "${_TMPDIR}" ; then
	mkdir -- "${_TMPDIR}"
fi

exit 0
