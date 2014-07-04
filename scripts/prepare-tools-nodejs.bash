#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`nodejs\` (NodeJS)..." >&2

if test -e "${_tools}/pkg/nodejs" ; then
	echo "[ii] \`nodejs\` already exists; aborting!" >&2
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

(
	export PATH="${_PATH}" CFLAGS="${_CFLAGS}" LDFLAGS="${_LDFLAGS}" LIBS="${_LIBS}"
	./configure --prefix="${_tools}/pkg/nodejs" --shared-openssl || exit 1
	make -j 8 || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/nodejs"

(
	export PATH="${_PATH}"
	make install || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

find -H "${_tools}/pkg/nodejs/bin" -xtype f -executable \
		-exec ln -s -t "${_tools}/bin" {} \;

echo "[ii] bootstrapping..." >&2

( . "${_scripts}/prepare-tools-nodejs-caches.bash" ; )

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/nodejs"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

echo "[ii] preparing..." >&2

exit 0
