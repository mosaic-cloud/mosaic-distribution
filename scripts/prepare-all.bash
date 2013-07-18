#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_mosaic_do_prerequisites}" == true ; then
	"${_scripts}/prepare-tools"
	"${_scripts}/prepare-workbench"
	"${_scripts}/prepare-repositories"
	"${_scripts}/prepare-dependencies"
fi

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
fi

if test "${_mosaic_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/prepare"
fi

if test "${_mosaic_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/prepare"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/prepare"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/indexer/scripts/prepare"
fi

exit 0
