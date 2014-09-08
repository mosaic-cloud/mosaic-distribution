#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

cat <<EOS

pallur-workbench :
	!exec ${_scripts}/prepare-workbench

pallur-submodules : pallur-workbench
	!exec ${_scripts}/prepare-submodules

pallur-environment : pallur-workbench pallur-submodules pallur-os

EOS

exit 0
