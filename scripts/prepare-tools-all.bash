#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] preparing tools..." >&2

for _tool in env erlang nodejs nodejs-caches go maven maven-caches zeromq jzmq jansson ninja vbs ; do
	_script_exec env BASH_ENV="${_scripts}/_env.bash" bash -- "${_scripts}/prepare-tools-${_tool}.bash"
done

echo "[ii] sealing tools..." >&2

chmod -R a=rX -- "${_tools}"

exit 0
