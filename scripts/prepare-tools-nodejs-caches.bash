#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test ! -e "${_tools}/pkg/nodejs/cache" ; then
	if test -L "${_tools}/pkg/nodejs/cache" ; then
		_cache_store="$( readlink -- "${_tools}/pkg/nodejs/cache" )"
	else
		_cache_store="${_temporary}/nodejs--cache"
		ln -s -T -- "${_cache_store}" "${_tools}/pkg/nodejs/cache"
	fi
	if test ! -e "${_cache_store}" ; then
		mkdir -- "${_cache_store}"
	fi
fi

exit 0
