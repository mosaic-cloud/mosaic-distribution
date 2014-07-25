#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] preparing repositories..." >&2

if test "${_repositories_safe}" != true ; then
	echo "[ww] skipping!" >&2
	exit 0
fi

echo "[ii] initializing submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule init --quiet

echo "[ii] updating submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule update --quiet --init --recursive

exit 0
