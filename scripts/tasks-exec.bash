#!/dev/null

if ! test "${#}" -ge 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_script_exec1 make -f <(
		cat <<'EOS'
.DEFAULT : default
.PHONY :
.SUFFIXES :
.PRECIOUS :
.SECONDARY :
.INTERMEDIATE :
.DELETE_ON_ERROR :
.POSIX :
EOS
		_script_exec1 "${_scripts}/tasks-all" \
		| sed -r -e 's#^\t#\t'"${_scripts}/.exec"' #'
) \
	-s -R -r -e --warn-undefined-variables \
	-j 1 \
	-- "${@}"

exit 0
