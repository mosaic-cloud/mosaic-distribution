#!/dev/null

if ! test "${#}" -ne 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_do_bash "${@}"

exit 0
