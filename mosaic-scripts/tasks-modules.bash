#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_modules=(
		mosaic-node
		mosaic-node-wui
		mosaic-node-boot
		mosaic-components-couchdb
		mosaic-components-rabbitmq
		mosaic-components-riak-kv
		mosaic-components-mysql
		mosaic-components-me2cp
		mosaic-components-httpg
		mosaic-object-store
		mosaic-java-platform/artifacts
		mosaic-java-platform/components-container
		mosaic-java-platform/cloudlets
		mosaic-java-platform/drivers-stubs/amqp
		mosaic-java-platform/drivers-stubs/riak
		mosaic-mos-platform-packages
		mosaic-applications-realtime-feeds/backend
		mosaic-applications-realtime-feeds/frontend
		mosaic-applications-realtime-feeds/indexer
)

for _module in "${_modules[@]}" ; do
	_module="$( readlink -e -- "${_repositories}/${_module}" )"
	_do_exec1 "${_module}/scripts/tasks"
done

exit 0
