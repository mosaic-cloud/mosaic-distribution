#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_do_node}" == true ; then
	_script_exec "${_repositories}/mosaic-node/scripts/package"
	_script_exec "${_repositories}/mosaic-node-wui/scripts/package"
	_script_exec "${_repositories}/mosaic-node-boot/scripts/package"
	if test "${_do_mos}" == true ; then
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-platform-controller
	fi
fi

if test "${_do_components}" == true ; then
	_script_exec "${_repositories}/mosaic-components-rabbitmq/scripts/package"
	_script_exec "${_repositories}/mosaic-components-riak-kv/scripts/package"
	_script_exec "${_repositories}/mosaic-components-couchdb/scripts/package"
	_script_exec "${_repositories}/mosaic-components-httpg/scripts/package"
	_script_exec "${_repositories}/mosaic-components-mysql/scripts/package"
	_script_exec "${_repositories}/mosaic-components-me2cp/scripts/package"
	if test "${_do_mos}" == true ; then
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-rabbitmq
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-riak-kv
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-couchdb
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-httpg
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-mysql
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-me2cp
	fi
fi

if test "${_do_java}" == true ; then
	_script_exec "${_repositories}/mosaic-java-platform/artifacts/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/components-container/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/cloudlets/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/package"
	_script_exec "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/package"
	if test "${_do_mos}" == true ; then
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-java-component-container
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-java-cloudlet-container
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-java-driver-amqp
		_script_exec "${_repositories}/mosaic-mos-platform-packages/scripts/package" mosaic-components-java-driver-riak
	fi
fi

if test "${_do_feeds}" == true ; then
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/backend/scripts/package"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/frontend/scripts/package"
	_script_exec "${_repositories}/mosaic-applications-realtime-feeds/indexer/scripts/package"
fi

exit 0
