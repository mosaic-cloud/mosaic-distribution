#!/dev/null

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] releasing \`${1}\`..." >&2

echo "${1}" >|"${_workbench}/version.txt"

echo "[ii] cleaning..." >&2
"${_scripts}/.clean"

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
