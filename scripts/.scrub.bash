#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] resetting submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule foreach --quiet --recursive \
			"${_git_bin} reset -q --hard HEAD"

echo "[ii] cleaning submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule foreach --quiet --recursive \
			"${_git_bin} clean -q -f -d -x"

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
