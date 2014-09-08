#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`nodejs\` (NodeJS)..." >&2

if test -e "${_tools}/pkg/nodejs" ; then
	echo "[ii] \`nodejs\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/nodejs\`)" >&2
	exit 0
fi

_outputs="${_temporary}/nodejs--build"
_repository="${_dependencies}/nodejs/0.10.21"

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

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	./configure \
		--prefix="${_tools}/pkg/nodejs" \
		--shared-openssl

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	make -j 8

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/nodejs"

_do_exec \
	make install

echo "[ii] bootstrapping..." >&2

( . "${_workbench}/mosaic-scripts/prepare-nodejs-caches.bash" ; )

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/nodejs"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

echo "[ii] preparing..." >&2

exit 0
