#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`go\` (Go Lang)..." >&2

if test -e "${_tools}/pkg/go" ; then
	echo "[ii] \`go\` already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/go\`)" >&2
	exit 0
fi

_outputs="${_outputs}/go--build"
_repository="${_repositories}/mosaic-dependencies/go/1.1.2"

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
	export GOROOT="${_outputs}" GOROOT_FINAL="${_tools}/pkg/go"
	cd ./src || exit 1
	./all.bash || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/go"

mv -t "${_tools}/pkg/go" -- \
		"${_outputs}/bin" \
		"${_outputs}/include" \
		"${_outputs}/lib" \
		"${_outputs}/pkg" \
		"${_outputs}/src"

find -H "${_tools}/pkg/go/bin" -xtype f -executable \
		-exec ln -s -t "${_tools}/bin" {} \;

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
