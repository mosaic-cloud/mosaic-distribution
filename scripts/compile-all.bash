#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_mosaic_do_node}" == true ; then
	_script_exec "${_repositories}/mosaic-erlang-tools/scripts/compile"
	_script_exec "${_repositories}/mosaic-node/scripts/compile"
	_script_exec "${_repositories}/mosaic-node-wui/scripts/compile"
fi

if test "${_mosaic_do_components}" == true ; then
	_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/compile"
	_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/compile"
	_script_exec "${_repositories}/mosaic-components-couchdb/scripts/compile"
	_script_exec "${_repositories}/mosaic-components-httpg/scripts/compile"
	_script_exec "${_repositories}/mosaic-components-mysql/scripts/compile"
	_script_exec "${_repositories}/mosaic-components-me2cp/scripts/compile"
fi

if test "${_mosaic_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/compile"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/compile"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/compile"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/compile"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/compile"
fi

if test "${_mosaic_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/compile"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/compile"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/indexer/scripts/compile"
fi

exit 0
