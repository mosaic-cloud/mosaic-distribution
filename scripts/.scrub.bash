#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] updating submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule update --quiet --recursive --force

echo "[ii] resetting submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule foreach --quiet --recursive \
			"${_git_bin} reset -q --hard HEAD"

echo "[ii] cleaning submodules..." >&2
env -i "${_git_env[@]}" "${_git_bin}" \
		submodule foreach --quiet --recursive \
			"${_git_bin} clean -q -f -d -x"

exit 0
