#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

#echo "[ii] building \`zeromq\` (ZeroMQ)..." >&2

cd -- "${_repositories}/zeromq"

if test -e "${_tools}/pkg/zeromq" ; then
	#echo "[ww] \`zeromq\` libary already exists; aborting!" >&2
	#echo "[ww] (to force the build remove the folder \`${_tools}/pkg/zeromq\`)" >&2
	exit 0
fi

_CFLAGS=''
_LDFLAGS=''

#echo "[ii] building..." >&2

(
	export CFLAGS="${_CFLAGS}" LDFLAGS="${_LDFLAGS}" PATH="${_PATH}"
	./autogen.sh || exit 1
	./configure --prefix="${_tools}/pkg/zeromq" || exit 1
	make || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

#echo "[ii] deploying..." >&2

(
	export PATH="${_PATH}"
	make install || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

mkdir -p -- "${_tools}/lib"
cp -T -- "${_tools}/pkg/zeromq/lib/libzmq.so.1" "${_tools}/lib/libzmq.so.1"

#echo "[ii] cleaning..." >&2

"${_git_bin}" reset -q --hard
"${_git_bin}" clean -q -f -d -x

exit 0
