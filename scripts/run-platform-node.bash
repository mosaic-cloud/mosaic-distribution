#!/dev/null

_scripts_env=(
	PATH="$(
			find -L "${_mosaic_repositories}" -mindepth 1 \
					\( -name '.*' -not -name '.outputs' -prune \) -o \
					\( -xtype d -path '*/.outputs/package/bin' -printf "%p:" \) \
				2>/dev/null \
			|| true
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
