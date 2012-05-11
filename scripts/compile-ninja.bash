#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

#echo "[ii] building \`ninja\` (Ninja build tool)..." >&2

cd -- "${_repositories}/ninja"

if test -e "${_tools}/bin/ninja" ; then
	#echo "[ww] \`ninja\` executable already exists; aborting!" >&2
	#echo "[ww] (to force the build remove the file \`${_tools}/bin/ninja\`)" >&2
	exit 0
fi

_CFLAGS=''
_LDFLAGS='-static'

#echo "[ii] building..." >&2

(
	export CFLAGS="${_CFLAGS}" LDFLAGS="${_LDFLAGS}" PATH="${_PATH}"
	./bootstrap.sh || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

#echo "[ii] deploying..." >&2

mkdir -p -- "${_tools}/bin"
cp -T -- "./ninja" "${_tools}/bin/ninja"

#echo "[ii] cleaning..." >&2

"${_git_bin}" reset -q --hard
"${_git_bin}" clean -q -f -d -x

exit 0
