#!/dev/null


if test "${#}" -eq 0 ; then
	_scripts_roots=( "${_scripts}" )
	_scripts_suffix='-all'
else
	_scripts_roots=()
	_scripts_suffix=''
	for _repository in "${@}" ; do
		_scripts_root="${_repositories}/${_repository}/scripts"
		test -e "${_scripts_root}"
		_scripts_roots+=( "${_scripts_root}" )
	done
fi


for _scripts_root in "${_scripts_roots[@]}" ; do
	
	if test "${mosaic_do_magic:-prepare}" == prepare ; then
		echo "[ii] preparing..." >&2
		_script_exec1 "${_scripts_root}/prepare${_scripts_suffix}"
		echo "[--]" >&2
	fi
	
	if test "${mosaic_do_magic:-compile}" == compile ; then
		echo "[ii] compiling..." >&2
		_script_exec1 "${_scripts_root}/compile${_scripts_suffix}"
		echo "[--]" >&2
	fi
	
	if test "${mosaic_do_magic:-package}" == package ; then
		echo "[ii] packaging..." >&2
		_script_exec1 "${_scripts_root}/package${_scripts_suffix}"
		echo "[--]" >&2
	fi
	
	if test "${mosaic_do_magic:-deploy}" == deploy ; then
		echo "[ii] deploying..." >&2
		if test "${pallur_deploy_skip:-true}" != true ; then
			_script_exec1 "${_scripts_root}/deploy${_scripts_suffix}"
		else
			echo "[ww]   -- skipped!" >&2
		fi
		echo "[--]" >&2
	fi
	
done

exit 0
