#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`zeromq\` (ZeroMQ)..." >&2

if test -e "${_tools}/pkg/zeromq" ; then
	echo "[ii] \`zeromq\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/zeromq\`)" >&2
	exit 0
fi

_outputs="${_temporary}/zeromq--build"
_repository="${_repositories}/zeromq2"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
chmod -R a=rX,u=rwX -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="${pallur_CFLAGS}"
_LDFLAGS="${pallur_LDFLAGS}"
_LIBS="${pallur_LIBS}"

echo "[ii] building..." >&2

_do_exec \
	./autogen.sh

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	./configure \
		--prefix="${_tools}/pkg/zeromq"

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	make -j 8

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/zeromq"

_do_exec \
	make install

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/zeromq"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
