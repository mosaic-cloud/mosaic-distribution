#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_outputs="${_temporary}/mosaic-node-boot"

if test "${_mosaic_deploy_cook:-true}" == true ; then
	test -e "${_outputs}/package.tar.gz"
	ssh -T "${_distribution_cook}" <"${_outputs}/package.tar.gz"
fi

exit 0
