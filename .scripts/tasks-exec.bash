#!/dev/null

if ! test "${#}" -ge 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_make_jobs=4
_make_load=8

_make_arguments=(
	--directory="${_temporary}"
	--jobs="${_make_jobs}"
	--load-average="${_make_load}"
	--keep-going
	--no-builtin-rules
	--no-builtin-variables
	--warn-undefined-variables
	--silent
	--no-print-directory
	--output-sync=target
)

_do_exec1 make \
		"${_make_arguments[@]}" \
		-f <( cat <<'EOS'
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
	-- "${@}"

exit 0
