#!/dev/null

_scripts_env=(
	PATH="$(
			find "${_mosaic_repositories}" \
					-xtype d \
					-name '.outputs' \
					-exec test -e {}/package/bin \; \
					-printf "%p/package/bin:"
	)${_PATH}"
	HOME="${_tools}/home"
	TMPDIR="${_temporary}"
)

if test -n "${_mosaic_log:-}" ; then
	_scripts_env+=(
			mosaic_node_log="${_mosaic_log}"
	)
	exec >"${_mosaic_log}" 2>&1
fi

if test "${#}" -eq 0 ; then
	exec env -i "${_scripts_env[@]}" mosaic-node--run-node
else
	exec env -i "${_scripts_env[@]}" mosaic-node--run-node "${@}"
fi

exit 1
