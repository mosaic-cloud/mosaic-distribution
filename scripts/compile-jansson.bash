#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`jansson\` (C JSON library)..." >&2

if test -e "${_tools}/pkg/jansson" ; then
	echo "[ii] \`jansson\` libary already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/jansson\`)" >&2
	exit 0
fi

_outputs="${_outputs}/jansson--build"
_repository="${_repositories}/jansson"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="${mosaic_CFLAGS}"
_LDFLAGS="${mosaic_LDFLAGS}"
_LIBS="${mosaic_LIBS}"

echo "[ii] building..." >&2

(
	export PATH="${_PATH}" CFLAGS="${_CFLAGS}" LDFLAGS="${_LDFLAGS}" LIBS="${_LIBS}"
	autoreconf -i || exit 1
	./configure --prefix="${_tools}/pkg/jansson" || exit 1
	make || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/jansson"

(
	export PATH="${_PATH}"
	make install || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
