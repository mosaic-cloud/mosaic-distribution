#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] updating repositories..." >&2
env -i "${_git_env}" "${_git_bin}" \
		submodule update --quiet --init --recursive

exit 0
