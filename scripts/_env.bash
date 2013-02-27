#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV

_workbench="$( readlink -e -- . )"
_repositories="${_workbench}/repositories"
_scripts="${_workbench}/scripts"
_outputs="${_workbench}/.outputs"
_tools="${_workbench}/.tools"
_temporary="/tmp/$( basename -- "${_workbench}" )--$( readlink -e -- "${_workbench}" | tr -d '\n' | md5sum -t | tr -d ' \n-' )"

_PATH_EXTRA="${PATH_EXTRA:-}"
_PATH_CLEAN="/opt/bin:/usr/local/bin:/usr/bin:/bin"
_PATH="$( echo "${_tools}/bin:${_PATH_EXTRA}:${_PATH_CLEAN}" | tr -s ':' )"

_git_bin="$( PATH="${_PATH}" type -P -- git || true )"
if test -z "${_git_bin}" ; then
	echo "[ww] missing \`git\` (Git DSCV) executable in path: \`${_PATH}\`; ignoring!" >&2
	_git_bin=git
fi

_distribution_version="$( cat "${_workbench}/version.txt" )"
_distribution_cook=cook@agent1.builder.mosaic.ieat.ro.

if test -e /etc/mos-release ; then
	_distribution_local_os_identifier="$( tr ':' '\n' </etc/mos-release | tail -n +2 | head -n 1 )"
	_distribution_local_os_version="$( tr ':' '\n' </etc/mos-release | tail -n +3 | head -n 1 )"
elif test -e /etc/slitaz-release ; then
	_distribution_local_os_identifier=slitaz
	_distribution_local_os_version="$( cat /etc/slitaz-release )"
elif test -e /etc/arch-release ; then
	_distribution_local_os_identifier=archlinux
	_distribution_local_os_version=rolling
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
	mosaic_distribution_tools="${_tools}"
	mosaic_distribution_temporary="${_temporary}"
	
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
	HOME="${HOME:-${_tools}/home}"
	JAVA_HOME="${_tools}/pkg/java"
	MAVEN_HOME="${_tools}/pkg/mvn"
	M2_HOME="${_tools}/pkg/mvn"
	TMPDIR="${_temporary}"
)

if test "${_mosaic_do_all:-true}" == false ; then
	_mosaic_do_node="${_mosaic_do_node:-false}"
	_mosaic_do_components="${_mosaic_do_components:-false}"
	_mosaic_do_java="${_mosaic_do_java:-false}"
	_mosaic_do_examples="${_mosaic_do_examples:-false}"
	_mosaic_do_feeds="${_mosaic_do_feeds:-false}"
else
	_mosaic_do_node="${_mosaic_do_node:-true}"
	_mosaic_do_components="${_mosaic_do_components:-true}"
	_mosaic_do_java="${_mosaic_do_java:-true}"
	_mosaic_do_examples="${_mosaic_do_examples:-true}"
	_mosaic_do_feeds="${_mosaic_do_feeds:-true}"
fi

if test "${_mosaic_deploy_skip:-false}" == true ; then
	_scripts_env+=(
		_mosaic_deploy_cook="${_mosaic_deploy_cook:-false}"
		_mosaic_deploy_artifactory="${_mosaic_deploy_artifactory:-false}"
	)
else
	_scripts_env+=(
		_mosaic_deploy_cook="${_mosaic_deploy_cook:-true}"
		_mosaic_deploy_artifactory="${_mosaic_deploy_artifactory:-false}"
	)
fi

if test -n "${SSH_AUTH_SOCK:-}" ; then
	_scripts_env+=( SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" )
fi

function _script_exec () {
	test "${#}" -ge 1
	echo "[ii] executing script \`${@:1}\`..." >&2
	_outcome=0
	env -i "${_scripts_env[@]}" "${@}" 2>&1 \
	| sed -u -r -e 's!^.*$![  ] &!g' >&2 \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ww] failed with ${_outcome}" >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		echo "[--]" >&2
		return 0
	fi
}
