#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_do_prerequisites}" == true ; then
	_script_exec "${_scripts}/prepare-workbench"
	_script_exec "${_scripts}/prepare-repositories"
	_script_exec "${_scripts}/prepare-tools-all"
fi

if test "${_do_node}" == true ; then
	_script_exec "${_repositories}/mosaic-node/scripts/prepare"
	_script_exec "${_repositories}/mosaic-node-wui/scripts/prepare"
	_script_exec "${_repositories}/mosaic-node-boot/scripts/prepare"
	if test "${_do_mos}" == true ; then
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-platform-controller
	fi
fi

if test "${_do_components}" == true ; then
	_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-couchdb/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-httpg/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-mysql/scripts/prepare"
	_script_exec "${_repositories}/mosaic-components-me2cp/scripts/prepare"
	if test "${_do_mos}" == true ; then
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-rabbitmq
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-riak-kv
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-couchdb
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-httpg
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-mysql
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-me2cp
	fi
fi

if test "${_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/prepare"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/prepare"
	if test "${_do_mos}" == true ; then
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-java-component-container
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-java-cloudlet-container
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-java-driver-amqp
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/prepare" mosaic-components-java-driver-riak
	fi
fi

if test "${_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/prepare"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/prepare"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/indexer/scripts/prepare"
fi

exit 0
