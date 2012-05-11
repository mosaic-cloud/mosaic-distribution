#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-tools/scripts/package"

env "${_scripts_env[@]}" "${_repositories}/mosaic-node/scripts/package"

env "${_scripts_env[@]}" "${_repositories}/mosaic-node-wui/scripts/package"

env "${_scripts_env[@]}" "${_repositories}/mosaic-components-rabbitmq/scripts/package"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-riak-kv/scripts/package"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-httpg/scripts/package"

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-drivers/scripts/package"

if test "${_mosaic_do_all_java:-${_mosaic_do_all:-true}}" == true ; then
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/components-container/scripts/package"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/cloudlets/scripts/package"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/package"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/package"
fi

if test "${_mosaic_do_all_examples:-${_mosaic_do_all:-true}}" == true ; then
	env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/backend/scripts/package"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/package"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/package"
fi

env "${_scripts_env[@]}" "${_scripts}/package-boot"

exit 0
