#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test ! -e "${_tools}/pkg/mvn/repo" ; then
	if test -L "${_tools}/pkg/mvn/repo" ; then
		_repo_store="$( readlink -- "${_tools}/pkg/mvn/repo" )"
	else
		_repo_store="${_temporary}/mvn--repository"
		ln -s -T -- "${_repo_store}" "${_tools}/pkg/mvn/repo"
	fi
	if test ! -e "${_repo_store}" ; then
		mkdir -- "${_repo_store}"
	fi
fi

exit 0
