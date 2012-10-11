#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] cleaning outputs and temporary..." >&2

if test -e "${_outputs}" ; then
	_outputs="$( readlink -e -- "${_outputs}" )"
	chmod -R o+w -- "${_outputs}"
	rm -Rf -- "${_outputs}"
fi
if test -L "${_outputs}" ; then
	rm -- "${_outputs}"
fi

if test -e "${_temporary}" ; then
	_temporary="$( readlink -e -- "${_temporary}" )"
	chmod -R o+w -- "${_temporary}"
	rm -Rf -- "${_temporary}"
fi
if test -L "${_temporary}" ; then
	rm -- "${_temporary}"
fi

echo "[ii] cleaning repositories..." >&2

"${_git_bin}" submodule update --quiet --init --recursive
"${_git_bin}" submodule foreach --quiet --recursive 'chmod -R +w . && git reset -q --hard HEAD && git clean -q -f -d -x'

exit 0
