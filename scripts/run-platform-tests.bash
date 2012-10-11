#!/dev/null

if ! test "${#}" -eq 2 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_scripts_env=(
	PATH="$(
			find "${_repositories}" \
					-xtype d \
					-name '.outputs' \
					-exec test -e {}/package/bin \; \
					-printf "%p/package/bin:"
	)${_PATH}"
	HOME="${_tools}/home"
	TMPDIR="${_temporary}"
)

exec env -i "${_scripts_env[@]}" mosaic-node--run-tests "${@}"

exit 1
