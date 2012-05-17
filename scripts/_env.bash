#!/dev/null

_workbench="$( readlink -e -- . )"
_repositories="${_workbench}/repositories"
_scripts="${_workbench}/scripts"
_tools="${_workbench}/.tools"
_outputs="${_workbench}/.outputs"

_PATH="${_tools}/bin:${PATH}"

_git_bin="$( PATH="${_PATH}" type -P -- git || true )"
if test -z "${_git_bin}" ; then
	echo "[ww] missing \`git\` (Git DSCV) executable in path: \`${_PATH}\`; ignoring!" >&2
	_git_bin=git
fi

_distribution_version=0.2.0_mosaic_dev
_distribution_cook=cook@agent1.builder.mosaic.ieat.ro.

if test -e /etc/mos-release ; then
	_distribution_local_os_identifier="$( tr ':' '\n' </etc/mos-release | tail -n +2 | head -n 1 )"
	_distribution_local_os_version="$( tr ':' '\n' </etc/mos-release | tail -n +3 | head -n 1 )"
elif test -e /etc/slitaz-release ; then
	_distribution_local_os_identifier=slitaz
	_distribution_local_os_version="$( cat /etc/slitaz-release )"
elif test -e /etc/lsb-release ; then
	_distribution_local_os_identifier="$( . /etc/lsb-release ; echo "${DISTRIB_ID:-}" )"
	_distribution_local_os_version="$( . /etc/lsb-release ; echo "${DISTRIB_RELEASE:-}" )"
else
	_distribution_local_os_identifier=
	_distribution_local_os_version=
fi

_distribution_local_os_identifier="${_distribution_local_os_identifier,,}"
_distribution_local_os_version="${_distribution_local_os_version,,}"
_distribution_local_os="${_distribution_local_os_identifier:-unknown}::${_distribution_local_os_version:-unknown}"

_scripts_env=(
	
	mosaic_distribution_version="${_distribution_version}"
	mosaic_distribution_cook="${_distribution_cook}"
	
	mosaic_local_os_identifier="${_distribution_local_os_identifier}"
	mosaic_local_os_version="${_distribution_local_os_version}"
	mosaic_local_os="${_distribution_local_os}"
	
	mosaic_pkg_erlang="${_tools}/pkg/erlang"
	mosaic_pkg_zeromq="${_tools}/pkg/zeromq"
	mosaic_pkg_java="${_tools}/pkg/java"
	mosaic_pkg_mvn="${_tools}/pkg/mvn"
	mosaic_pkg_jzmq="${_tools}/pkg/jzmq"
	
	mosaic_CFLAGS="-I${_tools}/include"
	mosaic_LDFLAGS="-L${_tools}/lib"
	mosaic_LIBS=
	
	PATH="${_PATH}"
	JAVA_HOME="${_tools}/pkg/java"
	MAVEN_HOME="${_tools}/pkg/mvn"
	M2_HOME="${_tools}/pkg/mvn"
)

function _script_exec () {
	test "${#}" -ge 1
	echo "[ii] executing script \`${@:1}\`..." >&2
	env "${_scripts_env[@]}" "${@}" || _outcome="${?}"
	_outcome=0
	if test "${_outcome}" -ne 0 ; then
		echo "[ww] failed with ${_outcome}" >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		echo "[--]" >&2
		return 0
	fi
}
