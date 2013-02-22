#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

"${_scripts}/prepare-workbench"
"${_scripts}/prepare-tools"
"${_scripts}/prepare-repositories"

_script_exec "${_scripts}/compile-ninja"
_script_exec "${_scripts}/compile-vbs"
_script_exec "${_scripts}/compile-zeromq"
_script_exec "${_scripts}/compile-jzmq"
_script_exec "${_scripts}/compile-maven"

if test "${_mosaic_do_node}" == true ; then
	_script_exec "${_repositories}/mosaic-erlang-tools/scripts/prepare"
	_script_exec "${_repositories}/mosaic-node/scripts/prepare"
	_script_exec "${_repositories}/mosaic-node-wui/scripts/prepare"
fi

if test "${_mosaic_do_components}" == true ; then
	_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-couchdb/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-httpg/scripts/prepare"
	_script_exec "${_repositories}/mosaic-erlang-drivers/scripts/prepare"
fi

if test "${_mosaic_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-drivers-hdfs/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-connectors-dfs/artifacts/scripts/prepare"
fi

if test "${_mosaic_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/prepare"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/prepare"
fi

exit 0
