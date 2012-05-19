#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

"${_git_bin}" submodule foreach --quiet 'echo "$( pwd ) ${name} ${sha1}"' \
| while read path name sha1 ; do
	path="$( readlink -e "${name}" )"
	name="$( basename "${name}" )"
	orig_path="$( readlink -e ../mosaic-repositories )/${name}"
	if test ! -e "${orig_path}" ; then continue ; fi
	origin_sha1="$( cd "${orig_path}" ; exec git rev-parse HEAD ; )"
	if test "${sha1}" != "${origin_sha1}" ; then
		echo "# ${name} -> ${origin_sha1}"
		( cd "${path}" ; exec git fetch ; )
		if ( cd "${path}" ; exec git cat-file -e "${origin_sha1}" ; ) ; then
			( cd "${path}" ; exec git checkout "${origin_sha1}" ; )
		else
			echo "#### !!!!" >&2
		fi
	fi
done

exit 0
