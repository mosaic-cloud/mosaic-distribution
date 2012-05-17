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

env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/components-container/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/cloudlets/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/amqp/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/drivers-stubs/riak/scripts/deploy"

env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/backend/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-examples-realtime-feeds/frontend/scripts/deploy"
env "${_scripts_env[@]}" "${_repositories}/mosaic-java-platform/examples/realtime-feeds-indexer/scripts/deploy"

env "${_scripts_env[@]}" "${_scripts}/deploy-boot"

exit 0
