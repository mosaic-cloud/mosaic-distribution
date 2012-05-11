#!/dev/null

_workbench="$( readlink -e -- . )"
_repositories="${_workbench}/repositories"
_scripts="${_workbench}/scripts"
_tools="${_workbench}/.tools"
_outputs="${_workbench}/.outputs"

_PATH="${_tools}/bin:${PATH}"

_git_bin="$( PATH="${_PATH}" type -P -- git || true )"
if test -z "${_git_bin}" ; then
	echo "[ee] missing \`git\` (Git DSCV) executable in path: \`${_PATH}\`; ignoring!" >&2
	exit 1
fi

_distribution_version=0.2.0_mosaic_dev
_distribution_cook=cook@agent1.builder.mosaic.ieat.ro.
_distribution_local_os=unknown

_scripts_env=(
	PATH="${_PATH}"
	_mosaic_distribution_version="${_distribution_version}"
	_mosaic_distribution_cook="${_distribution_cook}"
)
