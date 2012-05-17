#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_script_exec "${_repositories}/mosaic-erlang-tools/scripts/compile"
_script_exec "${_repositories}/mosaic-node/scripts/compile"
_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/compile"
_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/compile"
_script_exec "${_repositories}/mosaic-components-httpg/scripts/compile"
_script_exec "${_repositories}/mosaic-erlang-drivers/scripts/compile"

_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/compile"
_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/compile"
_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/compile"
_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/compile"

_script_exec "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/compile"
_script_exec "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/compile"

exit 0
