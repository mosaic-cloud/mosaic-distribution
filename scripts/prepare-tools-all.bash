#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

for _tool in env erlang nodejs go maven zeromq jzmq jansson ninja vbs ; do
	env -i "${_scripts_env[@]}" BASH_ENV="${_scripts}/_env.bash" bash -- "${_scripts}/prepare-tools-${_tool}.bash"
	echo "[--]" >&2
done

exit 0
