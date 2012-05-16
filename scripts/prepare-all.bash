#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

env "${_scripts_env[@]}" "${_scripts}/prepare-workbench"

env "${_scripts_env[@]}" "${_scripts}/compile-ninja"
env "${_scripts_env[@]}" "${_scripts}/compile-vbs"
env "${_scripts_env[@]}" "${_scripts}/compile-zeromq"
env "${_scripts_env[@]}" "${_scripts}/compile-jzmq"
env "${_scripts_env[@]}" "${_scripts}/compile-maven"

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-tools/scripts/prepare"

env "${_scripts_env[@]}" "${_repositories}/mosaic-node/scripts/prepare"

env "${_scripts_env[@]}" "${_repositories}/mosaic-node-wui/scripts/prepare"

env "${_scripts_env[@]}" "${_repositories}/mosaic-components-rabbitmq/scripts/prepare"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-riak-kv/scripts/prepare"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-httpg/scripts/prepare"

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-drivers/scripts/prepare"

if test "${_mosaic_do_all_java:-${_mosaic_do_all:-true}}" == true ; then
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/components-container/scripts/prepare"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/cloudlets/scripts/prepare"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/prepare"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/prepare"
fi

if test "${_mosaic_do_all_examples:-${_mosaic_do_all:-true}}" == true ; then
	env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/backend/scripts/prepare"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/prepare"
	env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/prepare"
fi

exit 0
