#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_outputs="${_outputs}/mosaic-node-boot"
_package_name=mosaic-node-boot
_package_version="${_distribution_version}"
_utils_version="0.0.2"

if test -e "${_outputs}/package" ; then
	chmod +w -- "${_outputs}/package"
	rm -R -- "${_outputs}/package"
fi
if test -e "${_outputs}/package.tar.gz" ; then
	chmod +w -- "${_outputs}/package.tar.gz"
	rm -- "${_outputs}/package.tar.gz"
fi

mkdir -p -- "${_outputs}"
mkdir -- "${_outputs}/package"
mkdir -- "${_outputs}/package/bin"

sed -r \
		-e 's|@\{_package_name\}|'"${_package_name}"'|g' \
		-e 's|@\{_package_version\}|'"${_package_version}"'|g' \
		-e 's|@\{_utils_version\}|'"${_utils_version}"'|g' \
	>"${_outputs}/package/bin/run" <<'EOS'
#!/bin/bash

set -e -E -u -o pipefail || exit 1

export PATH="/opt/mosaic-utils-@{_utils_version}/bin:${PATH:-}"

_self_basename="$( basename -- "${0}" )"
_self_realpath="$( readlink -e -- "${0}" )"
cd "$( dirname -- "${_self_realpath}" )"
cd ..
_package="$( readlink -e -- . )"
cmp -s -- "${_package}/bin/run" "${_self_realpath}"

export PATH="$(
		find /opt -maxdepth 1 -exec test -d {} -a -d {}/bin \; -print \
		| sed -r -e 's|^.*$|&/bin|' \
		| tr '\n' ':'
):${PATH:-}"

if test -n "${mos_application_private_fqdn:-}" ; then
	mosaic_application_fqdn="${mos_application_private_fqdn}"
elif test -n "${mos_application_public_fqdn:-}" ; then
	mosaic_application_fqdn="${mos_application_public_fqdn}"
else
	mosaic_application_fqdn=
fi

if test -n "${mos_node_private_fqdn:-}" ; then
	mosaic_node_fqdn="${mos_node_private_fqdn}"
elif test -n "${mos_node_public_fqdn:-}" ; then
	mosaic_node_fqdn="${mos_node_public_fqdn}"
else
	mosaic_node_fqdn="$( hostname -f | tr ' ' '\n' | head -n 1 || true )"
fi

if test -n "${mos_node_private_ip:-}" ; then
	mosaic_node_ip="${mos_node_private_ip}"
elif test -n "${mos_node_public_ip:-}" ; then
	mosaic_node_ip="${mos_node_public_ip}"
else
	mosaic_node_ip="$( hostname -i | tr ' ' '\n' | head -n 1 || true )"
fi

mosaic_temporary="${mos_fs_tmp:-/tmp/mosaic}/platform"
mosaic_log="${mos_fs_log:-${mos_fs_tmp:-/tmp/mosaic}}/platform.log"

if test -n "${mosaic_application_fqdn}" ; then
	export mosaic_application_fqdn
fi
if test -n "${mosaic_node_fqdn}" ; then
	export mosaic_node_fqdn
fi
if test -n "${mosaic_node_ip}" ; then
	export mosaic_node_ip
fi
export mosaic_temporary
export mosaic_log

if test ! -e "${mosaic_temporary}" ; then
	mkdir -p -- "${mosaic_temporary}"
fi

if test ! -e "${mosaic_temporary}/.iptables" ; then
	touch "${mosaic_temporary}/.iptables"
	iptables -t nat -A PREROUTING -p tcp --dport 80 -m state --state NEW -j DNAT --to :31000
fi

exec </dev/null >/dev/null 2>|"${mosaic_log}" 1>&2

if test "${#}" -eq 0 ; then
	exec mosaic-node--run-node
else
	exec mosaic-node--run-node "${@}"
fi

exit 1
EOS

chmod +x -- "${_outputs}/package/bin/run"

sed -r \
		-e 's|@\{_package_name\}|'"${_package_name}"'|g' \
		-e 's|@\{_package_version\}|'"${_package_version}"'|g' \
		-e 's|@\{_utils_version\}|'"${_utils_version}"'|g' \
	>"${_outputs}/package/bin/upgrade" <<'EOS'
#!/bin/bash

set -e -E -u -o pipefail || exit 1

if test "${0}" != /tmp/@{_package_name}--upgrade ; then
	cp "${0}" /tmp/@{_package_name}--upgrade
	exec /tmp/@{_package_name}--upgrade
fi

tazpkg recharge mosaic-mshell
tazpkg get-install mosaic-utils-@{_utils_version} --forced
tazpkg get-install mosaic-node-@{_package_version} --forced
tazpkg get-install mosaic-node-wui-@{_package_version} --forced
tazpkg get-install mosaic-components-rabbitmq-@{_package_version} --forced
tazpkg get-install mosaic-components-riak-kv-@{_package_version} --forced
tazpkg get-install mosaic-components-couchdb-@{_package_version} --forced
tazpkg get-install mosaic-components-httpg-@{_package_version} --forced
tazpkg get-install mosaic-components-java-component-container-@{_package_version} --forced
tazpkg get-install mosaic-components-java-cloudlet-container-@{_package_version} --forced
tazpkg get-install mosaic-components-java-driver-amqp-@{_package_version} --forced
tazpkg get-install mosaic-components-java-driver-riak-@{_package_version} --forced
tazpkg get-install mosaic-components-java-driver-hdfs-@{_package_version} --forced
tazpkg get-install mosaic-examples-realtime-feeds-backend-@{_package_version} --forced
tazpkg get-install mosaic-examples-realtime-feeds-frontend-java-@{_package_version} --forced
tazpkg get-install mosaic-examples-realtime-feeds-indexer-java-@{_package_version} --forced
tazpkg get-install mosaic-node-boot-@{_package_version} --forced

exit 0
EOS

chmod +x -- "${_outputs}/package/bin/upgrade"

cat >"${_outputs}/package/pkg.json" <<EOS
{
	"package" : "${_package_name}",
	"version" : "${_package_version}",
	"maintainer" : "mosaic-developers@lists.info.uvt.ro",
	"description" : "mOSAIC node boot",
	"directories" : [ "bin" ],
	"depends" : [
		"mosaic-utils-${_utils_version}",
		"mosaic-node-${_package_version}",
		"mosaic-node-wui-${_package_version}",
		"mosaic-components-rabbitmq-${_package_version}",
		"mosaic-components-riak-kv-${_package_version}",
		"mosaic-components-couchdb-${_package_version}",
		"mosaic-components-httpg-${_package_version}",
		"mosaic-components-java-component-container-${_package_version}",
		"mosaic-components-java-cloudlet-container-${_package_version}",
		"mosaic-components-java-driver-amqp-${_package_version}",
		"mosaic-components-java-driver-riak-${_package_version}",
		"mosaic-components-java-driver-hdfs-${_package_version}",
		"mosaic-examples-realtime-feeds-backend-${_package_version}",
		"mosaic-examples-realtime-feeds-frontend-java-${_package_version}",
		"mosaic-examples-realtime-feeds-indexer-java-${_package_version}",
		"iptables"
	]
}
EOS

tar -czf "${_outputs}/package.tar.gz" -C "${_outputs}/package" .

exit 0
