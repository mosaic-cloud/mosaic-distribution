#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test -e "${_temporary}" ; then
	chmod -R o+w -- "${_temporary}"
	rm -Rf -- "${_temporary}"
fi

exit 0
