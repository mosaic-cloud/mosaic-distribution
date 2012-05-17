#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-tools/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-node/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-rabbitmq/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-riak-kv/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-components-httpg/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-erlang-drivers/scripts/compile"

env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/components-container/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/cloudlets/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/compile"

env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/compile"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/compile"

exit 0
