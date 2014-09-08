#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV

_workbench="$( readlink -e -- . )"
_scripts="${_workbench}/.scripts"

if test -e "${_workbench}/.local-env.bash" ; then
	. "${_workbench}/.local-env.bash"
fi

if test -z "${pallur_distribution_version:-}" ; then
	_distribution_version="0.7.0_dev"
	echo "[dd] using pallur-distribution-version -> \`${_distribution_version}\`;" >&2
else
	_distribution_version="${pallur_distribution_version}"
fi

_submodules_safe=true

if test -z "${pallur_repositories:-}" -o "${pallur_repositories:-}" == '*' ; then
	if test -e "${_workbench}/.local-repositories" -a "${pallur_repositories:-}" != '*' ; then
		_repositories="$( readlink -e -- "${_workbench}/.local-repositories" )"
		_submodules_safe=false
	else
		_repositories="${_workbench}/mosaic-repositories/repositories"
	fi
	echo "[dd] using pallur-repositories -> \`${_repositories}\`;" >&2
else
	_repositories="${pallur_repositories}"
	_submodules_safe=false
fi

if test -z "${pallur_dependencies:-}" -o "${pallur_repositories:-}" == '*' ; then
	if test -e "${_workbench}/.local-dependencies" -a "${pallur_repositories:-}" != '*' ; then
		_dependencies="$( readlink -e -- "${_workbench}/.local-dependencies" )"
		_submodules_safe=false
	else
		_dependencies="${_workbench}/mosaic-dependencies/dependencies"
	fi
	echo "[dd] using pallur-dependencies -> \`${_dependencies}\`;" >&2
else
	_dependencies="${pallur_dependencies}"
	_submodules_safe=false
fi

if test -z "${pallur_temporary:-}" -o "${pallur_temporary:-}" == '*' ; then
	if test -e "${_workbench}/.temporary" -a "${pallur_temporary:-}" != '*' ; then
		_temporary="$( readlink -e -- "${_workbench}/.temporary" )"
	else
		_temporary="${TMPDIR:-/tmp}/$( basename -- "${_workbench}" )--${_distribution_version}--$( readlink -e -- "${_workbench}" | tr -d '\n' | md5sum -t | tr -d ' \n-' )"
	fi
	echo "[dd] using pallur-temporary -> \`${_temporary}\`;" >&2
else
	_temporary="${pallur_temporary}"
fi

if test -z "${pallur_tools:-}" -o "${pallur_tools:-}" == '*' ; then
	if test -e "${_workbench}/.local-tools" -a "${pallur_tools:-}" != '*' ; then
		_tools="$( readlink -e -- "${_workbench}/.local-tools" )"
	else
		_tools="${_temporary}/__tools"
	fi
	echo "[dd] using pallur-tools -> \`${_tools}\`;" >&2
else
	_tools="${pallur_tools}"
fi

if test -z "${pallur_artifacts:-}" -o "${pallur_artifacts:-}" == '*' ; then
	if test -e "${_workbench}/.local-artifacts" -a "${pallur_artifacts:-}" != '*' ; then
		_artifacts="$( readlink -e -- "${_workbench}/.local-artifacts" )"
	else
		_artifacts="${_temporary}/__artifacts"
	fi
	echo "[dd] using pallur-artifacts -> \`${_artifacts}\`;" >&2
else
	_artifacts="${pallur_artifacts}"
fi

if test -z "${pallur_PATH:-}" -o "${pallur_PATH:-}" == '*' ; then
	if test -e "${_tools}/.prepared" ; then
		_PATH_export="${_tools}/bin"
		_PATH="${_PATH_export}"
		echo "[dd] using pallur-PATH -> \`${_PATH}\`;" >&2
	else
		_PATH_export=''
		_PATH="${_tools}/bin:/usr/local/bin:/usr/bin:/bin"
		echo "[dd] using pallur-PATH (temporary) -> \`${_PATH}\`;" >&2
	fi
else
	_PATH_export="${pallur_PATH}"
	_PATH="${_PATH_export}"
fi

if test -z "${pallur_HOME:-}" -o "${pallur_HOME:-}" == '*' ; then
	if test -e "${_workbench}/.local-home" -a "${pallur_HOME:-}" != '*' ; then
		_HOME="$( readlink -e -- "${_workbench}/.local-home" )"
	else
		_HOME="${_temporary}/__home"
	fi
	echo "[dd] using pallur-HOME -> \`${_HOME}\`;" >&2
else
	_HOME="${pallur_HOME}"
fi

if test -z "${pallur_TMPDIR:-}" -o "${pallur_TMPDIR:-}" == '*' ; then
	_TMPDIR="${_temporary}/__tmpdir"
	echo "[dd] using pallur-TMPDIR -> \`${_TMPDIR}\`;" >&2
else
	_TMPDIR="${pallur_TMPDIR}"
fi

if test -e /etc/arch-release ; then
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

_do_scripts_env=(
	
	pallur_distribution_version="${_distribution_version}"
	pallur_repositories="${_repositories}"
	pallur_dependencies="${_dependencies}"
	pallur_tools="${_tools}"
	pallur_temporary="${_temporary}"
	pallur_artifacts="${_artifacts}"
	
	pallur_local_os_identifier="${_local_os_identifier}"
	pallur_local_os_version="${_local_os_version}"
	pallur_local_os="${_local_os}"
	
	pallur_pkg_erlang_15="${_tools}/pkg/erlang-15"
	pallur_pkg_erlang_17="${_tools}/pkg/erlang-17"
	pallur_pkg_nodejs="${_tools}/pkg/nodejs"
	pallur_pkg_go="${_tools}/pkg/go"
	pallur_pkg_java="${_tools}/pkg/java"
	pallur_pkg_maven="${_tools}/pkg/maven"
	pallur_pkg_zeromq="${_tools}/pkg/zeromq"
	pallur_pkg_jzmq="${_tools}/pkg/jzmq"
	pallur_pkg_jansson="${_tools}/pkg/jansson"
	pallur_pkg_js_1_8_5="${_tools}/pkg/js-1.8.5"
	pallur_pkg_nspr_4_9="${_tools}/pkg/nspr-4.9"
	
	pallur_PATH="${_PATH_export}"
	pallur_HOME="${_HOME}"
	pallur_TMPDIR="${_TMPDIR}"
	pallur_CFLAGS="-I${_tools}/include"
	pallur_CXXFLAGS="-I${_tools}/include"
	pallur_LDFLAGS="-L${_tools}/lib"
	pallur_LIBS=
	
	pallur_do_exec="${_scripts}/_do-exec"
	pallur_do_bash="${_scripts}/_do-bash"
	
	PATH="${_PATH}"
	HOME="${_HOME}"
	TMPDIR="${_TMPDIR}"
)

_do_scripts_env_quiet="${pallur_do_scripts_env_quiet:-true}"

while read _do_scripts_env_var ; do
	_do_scripts_env+=( "${_do_scripts_env_var}" )
	case "${_do_scripts_env_var}" in
		( _pallur_* )
			echo "[ww] exporting private scripts variable \`${_do_scripts_env_var}\`;" >&2
		;;
	esac
	if test "${_do_scripts_env_quiet:-}" == false ; then
		echo "[dd] overriding scripts variable \`${_do_scripts_env_var}\`;" >&2
	fi
done < <(
	env \
	| grep -E \
			-e '^pallur_[^=]+=.*$' \
			-e '^_pallur_[^=]+=.*$' \
	|| true
)
_do_scripts_env+=( pallur_do_scripts_env_quiet=true )

if test -n "${SSH_AUTH_SOCK:-}" ; then
	_do_scripts_env+=( SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" )
fi

#### FIXME: Remove all environment variables and replace them with `_do_scripts_env`!

function _do_exec () {
	test "${#}" -ge 1
	echo "[ii] executing \`${@:1}\`..." >&2
	_do_exec_log="$( basename -- "${_workbench}" )--$( tr -d '\n' <<<"${*}" | md5sum -t | tr -d ' \n-' )--$( date '+%Y-%m-%d-%H-%M-%S-%N' ).log"
	if test -e "${_temporary}" ; then
		_do_exec_log="${_temporary}/${_do_exec_log}"
	elif test -e "${_TMPDIR}" ; then
		_do_exec_log="${_TMPDIR}/${_do_exec_log}"
	elif test -e /tmp ; then
		_do_exec_log="/tmp/${_do_exec_log}"
	else
		false
	fi
	_outcome=0
	env -i "${_do_scripts_env[@]}" "${@}" </dev/null >"${_do_exec_log}" 2>&1 \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ee] failed with ${_outcome}; log available at \`${_do_exec_log}\`" >&2
		tail -n 20 -- "${_do_exec_log}" | sed -u -r -e 's!^.*$![  ] &!g' >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		rm -- "${_do_exec_log}"
		return 0
	fi
}

function _do_bash () {
	test "${#}" -ge 1
	echo "[ii] executing \`${@:1}\`..." >&2
	_do_exec_log="$( basename -- "${_workbench}" )--$( tr -d '\n' <<<"${*}" | md5sum -t | tr -d ' \n-' )--$( date '+%Y-%m-%d-%H-%M-%S-%N' ).log"
	if test -e "${_temporary}" ; then
		_do_exec_log="${_temporary}/${_do_exec_log}"
	elif test -e "${_TMPDIR}" ; then
		_do_exec_log="${_TMPDIR}/${_do_exec_log}"
	elif test -e /tmp ; then
		_do_exec_log="/tmp/${_do_exec_log}"
	else
		false
	fi
	_outcome=0
	env -i "${_do_scripts_env[@]}" BASH_ENV="${_scripts}/_env.bash" bash -- "${@}" </dev/null >"${_do_exec_log}" 2>&1 \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ee] failed with ${_outcome}; log available at \`${_do_exec_log}\`" >&2
		tail -n 20 -- "${_do_exec_log}" | sed -u -r -e 's!^.*$![  ] &!g' >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		rm -- "${_do_exec_log}"
		return 0
	fi
}

function _do_exec1 () {
	test "${#}" -ge 1
	echo "[ii] executing \`${@:1}\`..." >&2
	_outcome=0
	env -i "${_do_scripts_env[@]}" "${@}" </dev/null \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ee] failed with ${_outcome}" >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		return 0
	fi
}

function _do_bash1 () {
	test "${#}" -ge 1
	echo "[ii] executing \`${@:1}\`..." >&2
	_outcome=0
	env -i "${_do_scripts_env[@]}" BASH_ENV="${_scripts}/_env.bash" bash -- "${@}" </dev/null \
	|| _outcome="${?}"
	if test "${_outcome}" -ne 0 ; then
		echo "[ee] failed with ${_outcome}" >&2
		echo "[--]" >&2
		return "${_outcome}"
	else
		return 0
	fi
}

_git_bin="$( PATH="${_PATH}" type -P -- git || true )"
if test -z "${_git_bin}" ; then
	echo "[ww] missing \`git\` (Git DSCV) executable in path: \`${_PATH}\`; ignoring!" >&2
	_git_bin=git
fi

_generic_env=(
		PATH="${_PATH}"
		HOME="${_HOME}"
		TMPDIR="${_TMPDIR}"
)

_git_args=()
_git_env=(
		"${_generic_env[@]}"
)
