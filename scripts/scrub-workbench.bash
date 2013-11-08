#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


echo "[ii] scrubbing outputs..." >&2

if test -e "${_outputs}" ; then
	_outputs_store="$( readlink -e -- "${_outputs}" )"
	chmod -R u+w -- "${_outputs_store}"
	rm -Rf -- "${_outputs_store}"
fi
if test -L "${_outputs}" ; then
	rm -- "${_outputs}"
fi


echo "[ii] scrubbing temporary..." >&2

if test -e "${_temporary}" ; then
	_temporary_store="$( readlink -e -- "${_temporary}" )"
	chmod -R u+w -- "${_temporary_store}"
	rm -Rf -- "${_temporary_store}"
fi
if test -L "${_temporary}" ; then
	rm -- "${_temporary}"
fi


exit 0
