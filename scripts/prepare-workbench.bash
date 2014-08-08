#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] preparing workbench..." >&2

if test ! -e "${_temporary}" ; then
	mkdir -- "${_temporary}"
fi
if test ! -e "${_artifacts}" ; then
	mkdir -- "${_artifacts}"
fi
if test ! -e "${_HOME}" ; then
	mkdir -- "${_HOME}"
fi
if test ! -e "${_TMPDIR}" ; then
	mkdir -- "${_TMPDIR}"
fi

exit 0
