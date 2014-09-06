#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


cat <<EOS

default : default@prepare default@compile default@package default@deploy

EOS


for _task in requisites prepare compile package deploy ; do
	cat <<EOS

default@${_task} : mosaic-distribution@all@${_task}

mosaic-distribution@all@${_task} : \
		mosaic-distribution@platform-core@${_task} \
		mosaic-distribution@platform-java@${_task}

mosaic-distribution@node@${_task} : \
		mosaic-node@${_task} \
		mosaic-node-wui@${_task} \
		mosaic-node-boot@${_task}

mosaic-distribution@components@${_task} : \
		mosaic-components-couchdb@${_task} \
		mosaic-components-rabbitmq@${_task} \
		mosaic-components-riak-kv@${_task} \
		mosaic-components-mysql@${_task} \
		mosaic-components-me2cp@${_task} \
		mosaic-components-httpg@${_task}

mosaic-distribution@platform-core@${_task} : \
		mosaic-distribution@node@${_task} \
		mosaic-distribution@components@${_task}

mosaic-distribution@platform-java@${_task} : \
		mosaic-java-platform-artifacts@${_task} \
		mosaic-components-java-component-container@${_task} \
		mosaic-components-java-cloudlet-container@${_task} \
		mosaic-components-java-driver-amqp@${_task} \
		mosaic-components-java-driver-riak@${_task} \
		mosaic-distribution@node@${_task} \
		mosaic-distribution@components@${_task}

mosaic-distribution@applications@${_task} : \
		mosaic-applications-realtime-feeds-backend@${_task} \
		mosaic-applications-realtime-feeds-frontend-java@${_task} \
		mosaic-applications-realtime-feeds-indexer-java@${_task}

EOS
done


for _task in requisites prepare package deploy ; do
	cat <<EOS

default@${_task} : mosaic-distribution@all-rpm@${_task}

mosaic-distribution@all-rpm@${_task} : \
		mosaic-distribution@platform-core-rpm@${_task} \
		mosaic-distribution@platform-java-rpm@${_task}

mosaic-distribution@platform-core-rpm@${_task} : \
		mosaic-platform-core-rpm@${_task} \
		mosaic-distribution@node-rpm@${_task} \
		mosaic-distribution@components-rpm@${_task}

mosaic-distribution@platform-java-rpm@${_task} : \
		mosaic-platform-java-rpm@${_task} \
		mosaic-components-java-component-container-rpm@${_task} \
		mosaic-components-java-cloudlet-container-rpm@${_task} \
		mosaic-components-java-driver-amqp-rpm@${_task} \
		mosaic-components-java-driver-riak-rpm@${_task} \
		mosaic-distribution@node-rpm@${_task} \
		mosaic-distribution@components-rpm@${_task}

mosaic-distribution@node-rpm@${_task} : \
		mosaic-node-rpm@${_task} \
		mosaic-node-wui-rpm@${_task} \

mosaic-distribution@components-rpm@${_task} : \
		mosaic-components-couchdb-rpm@${_task} \
		mosaic-components-rabbitmq-rpm@${_task} \
		mosaic-components-riak-kv-rpm@${_task} \
		mosaic-components-mysql-rpm@${_task} \
		mosaic-components-me2cp-rpm@${_task} \
		mosaic-components-httpg-rpm@${_task}

EOS
done


cat <<EOS

pallur-bootstrap : pallur-workbench pallur-repositories pallur-environment

pallur-workbench :
	!bash ${_scripts}/prepare-workbench.bash

pallur-repositories : pallur-workbench
	!bash ${_scripts}/prepare-repositories.bash

pallur-environment : pallur-workbench pallur-repositories
	!bash ${_scripts}/prepare-tools-env.bash

pallur-packages@java : pallur-environment
pallur-packages@python-2 : pallur-environment
pallur-packages@rpm : pallur-environment

pallur-packages@jzmq : pallur-packages@zeromq

pallur-packages@mvn : pallur-packages@maven

pallur-packages@maven : pallur-packages@maven-caches
pallur-packages@nodejs : pallur-packages@nodejs-caches

EOS


for _tool in erlang-15 erlang-17 nodejs nodejs-caches go maven maven-caches zeromq jzmq jansson ninja vbs ; do
	cat <<EOS

pallur-packages@${_tool} : pallur-environment
	!bash ${_scripts}/prepare-tools-${_tool}.bash

pallur-packages : pallur-packages@{_tool}

EOS
done


for _module in \
		mosaic-node \
		mosaic-node-wui \
		mosaic-node-boot \
		mosaic-components-couchdb \
		mosaic-components-rabbitmq \
		mosaic-components-riak-kv \
		mosaic-components-mysql \
		mosaic-components-me2cp \
		mosaic-components-httpg \
		mosaic-java-platform/artifacts \
		mosaic-java-platform/components-container \
		mosaic-java-platform/cloudlets \
		mosaic-java-platform/drivers-stubs/amqp \
		mosaic-java-platform/drivers-stubs/riak \
		mosaic-mos-platform-packages \
		mosaic-applications-realtime-feeds/backend \
		mosaic-applications-realtime-feeds/frontend \
		mosaic-applications-realtime-feeds/indexer \
; do
	_module="$( readlink -e -- "${_repositories}/${_module}" )"
	_do_exec1 "${_module}/scripts/tasks"
done


exit 0
