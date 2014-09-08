#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`nspr-4.8\` (Mozilla NSPR library)..." >&2

if test -e "${_tools}/pkg/nspr-4.8" ; then
	echo "[ii] \`nspr-4.8\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/nspr-4.8\`)" >&2
	exit 0
fi

_outputs="${_temporary}/nspr-4.8--build"
_repository="${_dependencies}/mozilla-nspr/4.8"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
chmod -R a=rX,u=rwX -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="${pallur_CFLAGS}"
_CXXFLAGS="${pallur_CXXFLAGS}"
_LDFLAGS="${pallur_LDFLAGS}"
_LIBS="${pallur_LIBS}"

echo "[ii] building..." >&2

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			CXXFLAGS="${_CXXFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	./configure \
		--prefix="${_tools}/pkg/nspr-4.8" \
		--enable-static

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			CXXFLAGS="${_CXXFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	make -j 8

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/nspr-4.8"

_do_exec \
	make install

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/nspr-4.8"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
