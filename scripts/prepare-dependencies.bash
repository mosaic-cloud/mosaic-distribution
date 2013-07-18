#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_script_exec "${_scripts}/compile-erlang"
_script_exec "${_scripts}/compile-nodejs"
_script_exec "${_scripts}/compile-maven"
_script_exec "${_scripts}/compile-zeromq"
_script_exec "${_scripts}/compile-jzmq"
_script_exec "${_scripts}/compile-jansson"
_script_exec "${_scripts}/compile-ninja"
_script_exec "${_scripts}/compile-vbs"

exit 0
