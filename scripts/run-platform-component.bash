#!/dev/null

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_scripts_env+=(
	PATH="$(
			find -L "${_repositories}" -mindepth 1 \
					\( -name '.*' -not -name '.outputs' -prune \) -o \
					\( -xtype d -path '*/.outputs/package/bin' -printf "%p:" \) \
				2>/dev/null \
			|| true
	)${_PATH}"
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
