#!/dev/null


if test "${#}" -eq 0 ; then
	_scripts_roots=( "${_scripts}" )
	_scripts_suffix='-all'
else
	_scripts_roots=()
	_scripts_suffix=''
	for _repository in "${@}" ; do
		_scripts_root="${_mosaic_repositories}/${_repository}/scripts"
		test -e "${_scripts_root}"
		_scripts_roots+=( "${_scripts_root}" )
	done
fi


for _scripts_root in "${_scripts_roots[@]}" ; do
	
	echo "[ii] preparing..." >&2
	_script_exec "${_scripts_root}/prepare${_scripts_suffix}"
	echo "[--]" >&2
	
	echo "[ii] compiling..." >&2
	_script_exec "${_scripts_root}/compile${_scripts_suffix}"
	echo "[--]" >&2
	
	echo "[ii] packaging..." >&2
	_script_exec "${_scripts_root}/package${_scripts_suffix}"
	echo "[--]" >&2
	
	echo "[ii] deploying..." >&2
	if test "${_mosaic_deploy_skip:-true}" != true ; then
		_script_exec "${_scripts_root}/deploy${_scripts_suffix}"
	else
		echo "[ww]   -- skipped!" >&2
	fi
	echo "[--]" >&2
	
done

exit 0
