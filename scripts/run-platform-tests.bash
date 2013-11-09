#!/dev/null

if ! test "${#}" -eq 2 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_scripts_env+=(
	PATH="$(
			find -L "${_mosaic_repositories}" -mindepth 1 \
					\( -name '.*' -not -name '.outputs' -prune \) -o \
					\( -xtype d -path '*/.outputs/package/bin' -printf "%p:" \) \
				2>/dev/null \
			|| true
	)${_PATH}"
)

if test -n "${_mosaic_log:-}" ; then
	_scripts_env+=(
			mosaic_node_log="${_mosaic_log}"
	)
	exec >"${_mosaic_log}" 2>&1
fi

exec env -i "${_scripts_env[@]}" mosaic-node--run-tests "${@}"

exit 1
