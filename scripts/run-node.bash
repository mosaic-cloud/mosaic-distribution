#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_script_exec "${_repositories}/mosaic-node/scripts/run-node"

exit 0
