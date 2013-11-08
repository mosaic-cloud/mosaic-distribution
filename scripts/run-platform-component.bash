#!/dev/null

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

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

case "${1}" in
	( riak-kv )
		_command=( mosaic-components-riak-kv--run-component )
	;;
	( rabbitmq )
		_command=( mosaic-components-rabbitmq--run-component )
	;;
	( * )
		exit 1
	;;
esac

exec env -i "${_scripts_env[@]}" "${_command[@]}"

exit 1
