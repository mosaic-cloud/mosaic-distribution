#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV

_workbench="$( readlink -e -- . )"
_scripts="${_workbench}/scripts"
_outputs="${_workbench}/.outputs"
_tools="${_workbench}/.tools"
_temporary="/tmp/$( basename -- "${_workbench}" )--$( readlink -e -- "${_workbench}" | tr -d '\n' | md5sum -t | tr -d ' \n-' )"

_PATH_EXTRA="${_mosaic_path_extra:-}"
_PATH_CLEAN="${_mosaic_path_clean:-/opt/bin:/usr/local/bin:/usr/bin:/bin}"
_PATH="$( echo "${_tools}/bin:${_PATH_EXTRA}:${_PATH_CLEAN}" | tr -s ':' )"

if test -z "${_mosaic_repositories:-}" ; then
	if test -e "${_workbench}/.local-mosaic-repositories" ; then
		_mosaic_repositories="${_workbench}/.local-mosaic-repositories"
	else
		_mosaic_repositories="${_workbench}/mosaic-repositories/repositories"
	fi
	echo "[ii] using mosaic-repositories -> \`${_mosaic_repositories}\`" >&2
fi
if test -z "${_mosaic_dependencies:-}" ; then
	if test -e "${_workbench}/.local-mosaic-dependencies" ; then
		_mosaic_dependencies="${_workbench}/.local-mosaic-dependencies"
	else
		_mosaic_dependencies="${_workbench}/mosaic-dependencies/dependencies"
	fi
	echo "[ii] using mosaic-dependencies -> \`${_mosaic_dependencies}\`" >&2
fi

_distribution_version="$( cat "${_workbench}/version.txt" )"

if test -e /etc/mos-release ; then
	_local_os_identifier="$( tr ':' '\n' </etc/mos-release | tail -n +2 | head -n 1 )"
	_local_os_version="$( tr ':' '\n' </etc/mos-release | tail -n +3 | head -n 1 )"
elif test -e /etc/slitaz-release ; then
	_local_os_identifier=slitaz
	_local_os_version="$( cat /etc/slitaz-release )"
elif test -e /etc/arch-release ; then
	_local_os_identifier=archlinux
	_local_os_version=rolling
elif test -e /etc/lsb-release ; then
	_local_os_identifier="$( . /etc/lsb-release ; echo "${DISTRIB_ID:-}" )"
	_local_os_version="$( . /etc/lsb-release ; echo "${DISTRIB_RELEASE:-}" )"
else
	_local_os_identifier=
	_local_os_version=
fi

_local_os_identifier="${_local_os_identifier,,}"
_local_os_version="${_local_os_version,,}"
_local_os="${_local_os_identifier:-unknown}::${_local_os_version:-unknown}"

_scripts_env=(
	
	mosaic_distribution_version="${_distribution_version}"
	mosaic_distribution_tools="${_tools}"
	mosaic_distribution_temporary="${_temporary}"
	
	mosaic_local_os_identifier="${_local_os_identifier}"
	mosaic_local_os_version="${_local_os_version}"
	mosaic_local_os="${_local_os}"
	
	mosaic_pkg_erlang="${_tools}/pkg/erlang"
	mosaic_pkg_nodejs="${_tools}/pkg/nodejs"
	mosaic_pkg_go="${_tools}/pkg/go"
	mosaic_pkg_java="${_tools}/pkg/java"
	mosaic_pkg_mvn="${_tools}/pkg/mvn"
	mosaic_pkg_zeromq="${_tools}/pkg/zeromq"
	mosaic_pkg_jzmq="${_tools}/pkg/jzmq"
	mosaic_pkg_jansson="${_tools}/pkg/jansson"
	
	mosaic_CFLAGS="-I${_tools}/include"
	mosaic_LDFLAGS="-L${_tools}/lib"
	mosaic_LIBS=
	
	PATH="${_PATH}"
	HOME="${HOME:-${_tools}/home}"
	JAVA_HOME="${_tools}/pkg/java"
	MAVEN_HOME="${_tools}/pkg/mvn"
	M2_HOME="${_tools}/pkg/mvn"
	TMPDIR="${_temporary}"
	
	_mosaic_repositories="${_mosaic_repositories}"
	_mosaic_dependencies="${_mosaic_dependencies}"
)

case "${_mosaic_do_selection:-all}" in
	
	( all )
		_mosaic_do_prerequisites="${_mosaic_do_prerequisites:-true}"
		_mosaic_do_node="${_mosaic_do_node:-true}"
		_mosaic_do_components="${_mosaic_do_components:-true}"
		_mosaic_do_java="${_mosaic_do_java:-true}"
		_mosaic_do_examples="${_mosaic_do_examples:-true}"
		_mosaic_do_feeds="${_mosaic_do_feeds:-true}"
	;;
	
	( core )
		_mosaic_do_prerequisites="${_mosaic_do_prerequisites:-true}"
		_mosaic_do_node="${_mosaic_do_node:-true}"
		_mosaic_do_components="${_mosaic_do_components:-true}"
		_mosaic_do_java="${_mosaic_do_java:-false}"
		_mosaic_do_examples="${_mosaic_do_examples:-false}"
		_mosaic_do_feeds="${_mosaic_do_feeds:-false}"
	;;
	
	( core+java )
		_mosaic_do_prerequisites="${_mosaic_do_prerequisites:-true}"
		_mosaic_do_node="${_mosaic_do_node:-true}"
		_mosaic_do_components="${_mosaic_do_components:-true}"
		_mosaic_do_java="${_mosaic_do_java:-true}"
		_mosaic_do_examples="${_mosaic_do_examples:-false}"
		_mosaic_do_feeds="${_mosaic_do_feeds:-false}"
	;;
	
	( none )
		_mosaic_do_prerequisites="${_mosaic_do_prerequisites:-false}"
		_mosaic_do_node="${_mosaic_do_node:-false}"
		_mosaic_do_components="${_mosaic_do_components:-false}"
		_mosaic_do_java="${_mosaic_do_java:-false}"
		_mosaic_do_examples="${_mosaic_do_examples:-false}"
		_mosaic_do_feeds="${_mosaic_do_feeds:-false}"
	;;
esac

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
