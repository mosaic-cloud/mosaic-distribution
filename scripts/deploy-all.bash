#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_do_node}" == true ; then
	_script_exec "${_repositories}/mosaic-node/scripts/deploy"
	_script_exec "${_repositories}/mosaic-node-wui/scripts/deploy"
	_script_exec "${_repositories}/mosaic-node-boot/scripts/deploy"
fi

if test "${_do_components}" == true ; then
	_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/deploy"
	_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/deploy"
	_script_exec "${_repositories}/mosaic-components-couchdb/scripts/deploy"
	_script_exec "${_repositories}/mosaic-components-httpg/scripts/deploy"
	_script_exec "${_repositories}/mosaic-components-mysql/scripts/deploy"
	_script_exec "${_repositories}/mosaic-components-me2cp/scripts/deploy"
fi

if test "${_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/deploy"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/deploy"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/deploy"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/deploy"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/deploy"
fi

if test "${_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/deploy"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/deploy"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/indexer/scripts/deploy"
fi

exit 0
