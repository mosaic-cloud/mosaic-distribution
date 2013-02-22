#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_mosaic_do_node}" == true ; then
	_script_exec "${_repositories}/mosaic-erlang-tools/scripts/package"
	_script_exec "${_repositories}/mosaic-node/scripts/package"
	_script_exec "${_repositories}/mosaic-node-wui/scripts/package"
	_script_exec "${_scripts}/package-boot"
fi

if test "${_mosaic_do_components}" == true ; then
	_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/package"
	_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/package"
	_script_exec "${_repositories}/mosaic-components-couchdb/scripts/package"
	_script_exec "${_repositories}/mosaic-components-httpg/scripts/package"
	_script_exec "${_repositories}/mosaic-erlang-drivers/scripts/package"
fi

if test "${_mosaic_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/package"
	_script_exec "${_repositories}/mosaic-java-drivers-hdfs/scripts/package"
	_script_exec "${_repositories}/mosaic-java-connectors-dfs/artifacts/scripts/package"
fi

if test "${_mosaic_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/package"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/package"
fi

exit 0
