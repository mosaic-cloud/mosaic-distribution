#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV

_workbench="$( readlink -e -- . )"
_scripts="${_workbench}/scripts"

if test -z "${pallur_repositories:-}" ; then
	if test -e "${_workbench}/.local-mosaic-repositories" ; then
		_repositories="${_workbench}/.local-mosaic-repositories"
		_repositories_safe=false
	else
		_repositories="${_workbench}/mosaic-repositories/repositories"
		_repositories_safe=true
	fi
	echo "[dd] using mosaic-repositories -> \`${_repositories}\`;" >&2
else
	_repositories="${pallur_repositories}"
	_repositories_safe=false
fi
if test -z "${pallur_dependencies:-}" ; then
	if test -e "${_workbench}/.local-mosaic-dependencies" ; then
		_dependencies="${_workbench}/.local-mosaic-dependencies"
	else
		_dependencies="${_workbench}/mosaic-dependencies/dependencies"
	fi
	echo "[dd] using mosaic-dependencies -> \`${_dependencies}\`;" >&2
else
	_dependencies="${pallur_dependencies}"
fi
if test -z "${pallur_temporary:-}" ; then
	if test -e "${_workbench}/.temporary" ; then
		_temporary="${_workbench}/.temporary"
	else
		_temporary="${TMPDIR:-/tmp}/$( basename -- "${_workbench}" )--$( readlink -e -- "${_workbench}" | tr -d '\n' | md5sum -t | tr -d ' \n-' )"
	fi
	echo "[dd] using mosaic-temporary -> \`${_temporary}\`;" >&2
else
	_temporary="${pallur_temporary}"
fi
if test -z "${pallur_tools:-}" ; then
	if test -e "${_workbench}/.local-tools" ; then
		_tools="${_workbench}/.local-tools"
	else
		_tools="${_temporary}/__tools"
	fi
	echo "[dd] using mosaic-tools -> \`${_tools}\`;" >&2
else
	_tools="${pallur_tools}"
fi
if test -z "${pallur_artifacts:-}" ; then
	if test -e "${_workbench}/.local-artifacts" ; then
		_artifacts="${_workbench}/.local-artifacts"
	else
		_artifacts="${_temporary}/__artifacts"
	fi
	echo "[dd] using mosaic-artifacts -> \`${_artifacts}\`;" >&2
else
	_artifacts="${pallur_artifacts}"
fi
if test -z "${pallur_PATH:-}" ; then
	if test -e "${_tools}/.prepared" ; then
		_PATH_export="${_tools}/bin"
		_PATH="${_PATH_export}"
		echo "[dd] using mosaic-PATH -> \`${_PATH}\`;" >&2
	else
		_PATH_export=''
		_PATH="${_tools}/bin:/usr/local/bin:/usr/bin:/bin"
		echo "[dd] using mosaic-PATH (temporary) -> \`${_PATH}\`;" >&2
	fi
	echo "[dd] using mosaic-PATH -> \`${_PATH}\`;" >&2
else
	_PATH_export="${pallur_PATH}"
	_PATH="${_PATH_export}"
fi
if test -z "${pallur_HOME:-}" ; then
	if test -e "${_workbench}/.local-tools/home" ; then
		_HOME="${_workbench}/.local-tools/home"
	else
		_HOME="${_temporary}/__home"
	fi
	echo "[dd] using mosaic-HOME -> \`${_HOME}\`;" >&2
else
	_HOME="${pallur_HOME}"
fi
if test -z "${pallur_TMPDIR:-}" ; then
	_TMPDIR="${_temporary}/__tmpdir"
	echo "[dd] using mosaic-TMPDIR -> \`${_TMPDIR}\`;" >&2
else
	_TMPDIR="${pallur_TMPDIR}"
fi

if test -z "${pallur_distribution_version:-}" ; then
	_distribution_version="0.7.0_dev"
	echo "[dd] using mosaic-distribution-version -> \`${_distribution_version}\`;" >&2
else
	_distribution_version="${pallur_distribution_version}"
fi

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
	
	pallur_distribution_version="${_distribution_version}"
	pallur_repositories="${_repositories}"
	pallur_dependencies="${_dependencies}"
	pallur_tools="${_tools}"
	pallur_temporary="${_temporary}"
	pallur_artifacts="${_artifacts}"
	
	pallur_local_os_identifier="${_local_os_identifier}"
	pallur_local_os_version="${_local_os_version}"
	pallur_local_os="${_local_os}"
	
	pallur_pkg_erlang="${_tools}/pkg/erlang"
	pallur_pkg_nodejs="${_tools}/pkg/nodejs"
	pallur_pkg_go="${_tools}/pkg/go"
	pallur_pkg_java="${_tools}/pkg/java"
	pallur_pkg_mvn="${_tools}/pkg/mvn"
	pallur_pkg_zeromq="${_tools}/pkg/zeromq"
	pallur_pkg_jzmq="${_tools}/pkg/jzmq"
	pallur_pkg_jansson="${_tools}/pkg/jansson"
	
	pallur_PATH="${_PATH_export}"
	pallur_HOME="${_HOME}"
	pallur_TMPDIR="${_TMPDIR}"
	pallur_CFLAGS="-I${_tools}/include"
	pallur_CXXFLAGS="-I${_tools}/include"
	pallur_LDFLAGS="-L${_tools}/lib"
	pallur_LIBS=
	
	PATH="${_PATH}"
	HOME="${_HOME}"
	TMPDIR="${_TMPDIR}"
)

case "${mosaic_do_selection:-core+java}" in
	
	( all )
		_do_prerequisites="${mosaic_do_prerequisites:-true}"
		_do_node="${mosaic_do_node:-true}"
		_do_components="${mosaic_do_components:-true}"
		_do_java="${mosaic_do_java:-true}"
		_do_examples="${mosaic_do_examples:-true}"
		_do_feeds="${mosaic_do_feeds:-true}"
	;;
	
	( core )
		_do_prerequisites="${mosaic_do_prerequisites:-true}"
		_do_node="${mosaic_do_node:-true}"
		_do_components="${mosaic_do_components:-true}"
		_do_java="${mosaic_do_java:-false}"
		_do_examples="${mosaic_do_examples:-false}"
		_do_feeds="${mosaic_do_feeds:-false}"
	;;
	
	( core+java )
		_do_prerequisites="${mosaic_do_prerequisites:-true}"
		_do_node="${mosaic_do_node:-true}"
		_do_components="${mosaic_do_components:-true}"
		_do_java="${mosaic_do_java:-true}"
		_do_examples="${mosaic_do_examples:-false}"
		_do_feeds="${mosaic_do_feeds:-false}"
	;;
	
	( java )
		_do_prerequisites="${mosaic_do_prerequisites:-true}"
		_do_node="${mosaic_do_node:-false}"
		_do_components="${mosaic_do_components:-false}"
		_do_java="${mosaic_do_java:-true}"
		_do_examples="${mosaic_do_examples:-false}"
		_do_feeds="${mosaic_do_feeds:-false}"
	;;
	
	( none )
		_do_prerequisites="${mosaic_do_prerequisites:-false}"
		_do_node="${mosaic_do_node:-false}"
		_do_components="${mosaic_do_components:-false}"
		_do_java="${mosaic_do_java:-false}"
		_do_examples="${mosaic_do_examples:-false}"
		_do_feeds="${mosaic_do_feeds:-false}"
	;;
	
	( * )
		false
	;;
esac

_do_scripts_env_quiet="${mosaic_do_scripts_env_quiet:-true}"

while read _script_env_var ; do
	_scripts_env+=( "${_script_env_var}" )
	case "${_script_env_var}" in
		( _pallur_* | _mosaic_* | _mos_* )
			echo "[ww] exporting private scripts variable \`${_script_env_var}\`;" >&2
		;;
	esac
	if test "${_do_scripts_env_quiet:-}" == false ; then
		echo "[dd] overriding scripts variable \`${_script_env_var}\`;" >&2
	fi
done < <(
	env \
	| grep -E \
			-e '^pallur_[^=]+=.*$' \
			-e '^_pallur_[^=]+=.*$' \
			-e '^mosaic_[^=]+=.*$' \
			-e '^_mosaic_[^=]+=.*$' \
			-e '^mos_[^=]+=.*$' \
			-e '^_mos_[^=]+=.*$' \
	|| true
)
_scripts_env+=( mosaic_do_scripts_env_quiet=true )

if test -n "${SSH_AUTH_SOCK:-}" ; then
	_scripts_env+=( SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" )
fi

_git_bin="$( PATH="${_PATH}" type -P -- git || true )"
if test -z "${_git_bin}" ; then
	echo "[ww] missing \`git\` (Git DSCV) executable in path: \`${_PATH}\`; ignoring!" >&2
	_git_bin=git
fi

_git_args=()
_git_env=()
while read _git_env_var ; do
	_git_env+=( "${_git_env_var}" )
done < <( env )

function _script_exec () {
	test "${#}" -ge 1
	echo "[ii] executing \`${@:1}\`..." >&2
	_script_exec_log="$( basename -- "${_workbench}" )--$( tr -d '\n' <<<"${*}" | md5sum -t | tr -d ' \n-' )--$( date '+%Y-%m-%d-%H-%M-%S-%N' ).log"
	if test -e "${_temporary}" ; then
		_script_exec_log="${_temporary}/${_script_exec_log}"
	elif test -e "${_TMPDIR}" ; then
		_script_exec_log="${_TMPDIR}/${_script_exec_log}"
	elif test -e /tmp ; then
		_script_exec_log="/tmp/${_script_exec_log}"
	else
		false
	fi
	_outcome=0
	env -i "${_scripts_env[@]}" "${@}" </dev/null >"${_script_exec_log}" 2>&1 \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ee] failed with ${_outcome}; log available at \`${_script_exec_log}\`" >&2
		tail -n 20 -- "${_script_exec_log}" | sed -u -r -e 's!^.*$![  ] &!g' >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		rm -- "${_script_exec_log}"
		return 0
	fi
}

function _script_exec1 () {
	test "${#}" -ge 1
	echo "[ii] executing \`${@:1}\`..." >&2
	_outcome=0
	env -i "${_scripts_env[@]}" "${@}" </dev/null \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ee] failed with ${_outcome}" >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		return 0
	fi
}
