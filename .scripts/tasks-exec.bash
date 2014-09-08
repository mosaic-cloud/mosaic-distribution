#!/dev/null

if ! test "${#}" -ge 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_do_exec1 make -f <(
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
		_do_exec1 "${_scripts}/tasks-all" \
		| sed -r \
			-e 's#^\t!exec #\t'"${_scripts}/_do-exec"' #' -e 't' \
			-e 's#^\t!bash #\t'"${_scripts}/_do-bash"' #' -e 't' \
			-e '/^\t/! b' \
			-e 'w /dev/stderr' -e 'Q 1'
) \
	-s -R -r -e --warn-undefined-variables \
	-j 1 \
	-- "${@}"

exit 0
