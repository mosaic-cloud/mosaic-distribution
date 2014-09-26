#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_advance_auto_init:-false}" == true ; then
	echo "[ww] initializing submodules..." >&2
	env -i "${_git_env[@]}" "${_git_bin}" \
			submodule update --quiet --init .
fi

env -i "${_git_env[@]}" "${_git_bin}" \
		submodule foreach --quiet \
			'echo "$( pwd ) ${name} ${sha1}"' \
| while read path name sha1 ; do
	path="$( readlink -e "${name}" )"
	name="$( basename "${name}" )"
	case "${name}" in
		( mosaic-repositories )
			orig_path="$( readlink -e ../mosaic-distribution-repositories )"
		;;
		( mosaic-dependencies )
			orig_path="$( readlink -e ../mosaic-distribution-dependencies )"
		;;
		( * )
			continue
		;;
	esac
	if test "${orig_path}" == "${path}" ; then
		continue
	fi
	if test ! -e "${orig_path}" ; then
		echo "[ww] ?? ${name}" >&2
		continue
	fi
	origin_sha1="$(
			cd "${orig_path}"
			exec env -i "${_git_env[@]}" "${_git_bin}" rev-parse HEAD
	)"
	if test "${sha1}" != "${origin_sha1}" ; then
		echo "[ww] ## ${name} -> ${origin_sha1}" >&2
		(
			cd "${path}"
			exec env -i "${_git_env[@]}" "${_git_bin}" fetch
		)
		if (
				cd "${path}"
				exec env -i "${_git_env[@]}" "${_git_bin}" cat-file -e "${origin_sha1}"
		) ; then (
				cd "${path}"
				env -i "${_git_env[@]}" "${_git_bin}" checkout "${origin_sha1}"
				env -i "${_git_env[@]}" "${_git_bin}" submodule update --quiet --recursive --init --force
		) ; else
			echo "[ee] #### !!!!" >&2
		fi
		env -i "${_git_env[@]}" "${_git_bin}" add "${path}"
	else
		echo "[ii] -- ${name}" >&2
	fi
done

if test "${_advance_auto_init:-false}" == true ; then
	echo "[ww] deinitializing submodules..." >&2
	env -i "${_git_env[@]}" "${_git_bin}" \
			submodule deinit --quiet .
fi

exit 0
