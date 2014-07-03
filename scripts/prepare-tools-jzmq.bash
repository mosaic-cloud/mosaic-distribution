#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`jzmq\` (Java ZeroMQ)..." >&2

if test -e "${_tools}/pkg/jzmq" ; then
	echo "[ii] \`jzmq\` libary already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/jzmq\`)" >&2
	exit 0
fi

_outputs="${_temporary}/jzmq--build"
_repository="${_repositories}/jzmq"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="-I${pallur_pkg_java}/include ${pallur_CFLAGS}"
_LDFLAGS="-L${pallur_pkg_java}/lib ${pallur_LDFLAGS}"
_LIBS="${pallur_LIBS}"
_JAVA_HOME="${pallur_pkg_java}"

echo "[ii] building..." >&2

(
	export PATH="${_PATH}" CFLAGS="${_CFLAGS}" LDFLAGS="${_LDFLAGS}" LIBS="${_LIBS}" JAVA_HOME="${_JAVA_HOME}"
	./autogen.sh || exit 1
	./configure --prefix="${_tools}/pkg/jzmq" --with-zeromq="${pallur_pkg_zeromq}" || exit 1
	make -j 1 || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/jzmq"

(
	export PATH="${_PATH}" JAVA_HOME="${_JAVA_HOME}"
	make install || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

ln -s -T -- "${_tools}/pkg/jzmq/lib/libjzmq.so" "${_tools}/lib/libjzmq.so"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
