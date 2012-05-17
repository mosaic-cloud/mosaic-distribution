#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_script_exec "${_repositories}/mosaic-erlang-tools/scripts/package"
_script_exec "${_repositories}/mosaic-node/scripts/package"
_script_exec "${_repositories}/mosaic-node-wui/scripts/package"
_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/package"
_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/package"
_script_exec "${_repositories}/mosaic-components-httpg/scripts/package"
_script_exec "${_repositories}/mosaic-erlang-drivers/scripts/package"

_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/package"
_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/package"
_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/package"
_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/package"

_script_exec "${_repositories}/mosaic-examples-realtime-feeds/backend/scripts/package"
_script_exec "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/package"
_script_exec "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/package"

_script_exec "${_scripts}/package-boot"

exit 0
