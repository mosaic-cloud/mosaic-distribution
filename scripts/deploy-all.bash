#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-tools/scripts/deploy"

env "${_scripts_env[@]}" "${_repositories}/mosaic-node/scripts/deploy"

env "${_scripts_env[@]}" "${_repositories}/mosaic-node-wui/scripts/deploy"

env "${_scripts_env[@]}" "${_repositories}/mosaic-components-rabbitmq/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-riak-kv/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-httpg/scripts/deploy"

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-drivers/scripts/deploy"

if test "${_mosaic_do_all_java:-${_mosaic_do_all:-true}}" == true ; then
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/components-container/scripts/deploy"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/cloudlets/scripts/deploy"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/deploy"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/deploy"
fi

if test "${_mosaic_do_all_examples:-${_mosaic_do_all:-true}}" == true ; then
	env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/backend/scripts/deploy"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/deploy"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/deploy"
fi

env "${_scripts_env[@]}" "${_scripts}/deploy-boot"

exit 0
