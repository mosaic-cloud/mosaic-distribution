#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

for _task in requisites prepare package publish ; do
	cat <<EOS

mosaic-distribution@${_task} : \
		mosaic-distribution@all-rpm@${_task}

mosaic-distribution@all-rpm@${_task} : \
		mosaic-distribution@node-rpm@${_task} \
		mosaic-distribution@components-rpm@${_task} \
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

exit 0
