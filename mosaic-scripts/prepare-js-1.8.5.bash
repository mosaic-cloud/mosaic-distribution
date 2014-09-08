#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`js-1.8.5\` (Mozilla JS library)..." >&2

if test -e "${_tools}/pkg/js-1.8.5" ; then
	echo "[ii] \`js-1.8.5\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/js-1.8.5\`)" >&2
	exit 0
fi

_outputs="${_temporary}/js-1.8.5--build"
_repository="${_dependencies}/mozilla-js/1.8.5/js/src"

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
		--prefix="${_tools}/pkg/js-1.8.5" \
		--with-nspr-prefix="${_tools}/pkg/nspr-4.9" \
		--enable-static

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			CXXFLAGS="${_CXXFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	make -j 8

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/js-1.8.5"

_do_exec \
	make install

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/js-1.8.5"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
