#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_script_exec "${_repositories}/mosaic-erlang-tools/scripts/deploy"
_script_exec "${_repositories}/mosaic-node/scripts/deploy"
_script_exec "${_repositories}/mosaic-node-wui/scripts/deploy"
_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/deploy"
_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/deploy"
_script_exec "${_repositories}/mosaic-components-couchdb/scripts/deploy"
_script_exec "${_repositories}/mosaic-components-httpg/scripts/deploy"
_script_exec "${_repositories}/mosaic-erlang-drivers/scripts/deploy"

_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/deploy"
_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/deploy"
_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/deploy"
_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/deploy"
_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/deploy"

_script_exec "${_repositories}/mosaic-java-drivers-hdfs/scripts/deploy"
_script_exec "${_repositories}/mosaic-java-connectors-dfs/artifacts/scripts/deploy"

_script_exec "${_repositories}/mosaic-examples-realtime-feeds/backend/scripts/deploy"
_script_exec "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/deploy"
_script_exec "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/deploy"

_script_exec "${_scripts}/deploy-boot"

exit 0
