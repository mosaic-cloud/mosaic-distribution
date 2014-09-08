#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`go\` (Go Lang)..." >&2

if test -e "${_tools}/pkg/go" ; then
	echo "[ii] \`go\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/go\`)" >&2
	exit 0
fi

_outputs="${_temporary}/go--build"
_repository="${_dependencies}/go/1.1.2"

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

pushd -- ./src >/dev/null

_do_exec env \
			GOROOT="${_outputs}" \
			GOROOT_FINAL="${_tools}/pkg/go" \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}"
	./make.bash

popd >/dev/null

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/go"

mv -t "${_tools}/pkg/go" -- \
		"${_outputs}/bin" \
		"${_outputs}/include" \
		"${_outputs}/lib" \
		"${_outputs}/pkg" \
		"${_outputs}/src"

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/go"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
