#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${#}" -ge 1 ; then
	echo "${1}" >|"${_workbench}/version.txt"
fi

echo "[ii] releasing \`$( cat "${_workbench}/version.txt" )\`..." >&2

echo "[ii] preparing..." >&2
"${_scripts}/prepare-all"

echo "[ii] compiling..." >&2
"${_scripts}/compile-all"

echo "[ii] packaging..." >&2
"${_scripts}/package-all"

if test "${_mosaic_deploy_skip:-false}" != true ; then
	echo "[ii] deploying..." >&2
	"${_scripts}/deploy-all"
fi

exit 0
