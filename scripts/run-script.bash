#!/dev/null

if ! test "${#}" -ne 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

test -f "${1}"
test -x "${1}"

_script_exec "${@}"

exit 0
