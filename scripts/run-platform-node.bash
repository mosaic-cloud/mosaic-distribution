#!/dev/null

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

if test "${#}" -eq 0 ; then
	exec env -i "${_scripts_env[@]}" mosaic-node--run-node
else
	exec env -i "${_scripts_env[@]}" mosaic-node--run-node "${@}"
fi

exit 1
