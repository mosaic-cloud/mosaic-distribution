#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_outputs="${_outputs}/mosaic-node-boot"
_package_cook=cook@agent1.builder.mosaic.ieat.ro.

if test "${_mosaic_deploy_cook:-true}" == true ; then
	test -e "${_outputs}/package.tar.gz"
	ssh -T "${_package_cook}" <"${_outputs}/package.tar.gz"
fi

exit 0
