#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] preparing..." >&2
_script_exec "${_scripts}/prepare-all"
echo "[--]" >&2

echo "[ii] compiling..." >&2
_script_exec "${_scripts}/compile-all"
echo "[--]" >&2

echo "[ii] packaging..." >&2
_script_exec "${_scripts}/package-all"
echo "[--]" >&2

echo "[ii] deploying..." >&2
if test "${_mosaic_deploy_skip:-true}" != true ; then
	_script_exec "${_scripts}/deploy-all"
else
	echo "[ww]   -- skipped!" >&2
fi
echo "[--]" >&2

exit 0
