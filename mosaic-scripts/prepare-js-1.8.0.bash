#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`js-1.8.0\` (Mozilla JS library)..." >&2

if test -e "${_tools}/pkg/js-1.8.0" ; then
	echo "[ii] \`js-1.8.0\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/js-1.8.0\`)" >&2
	exit 0
fi

_outputs="${_temporary}/js-1.8.0--build"
_repository="${_dependencies}/mozilla-js/1.8.0/src"

echo "[ii] preparing..." >&2

if test -e "${_outputs}" ; then
	rm -R -- "${_outputs}"
fi
mkdir -- "${_outputs}"

cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
chmod -R a=rX,u=rwX -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="-I${_tools}/pkg/nspr-4.8/include/nspr -include unistd.h -include string.h -w ${pallur_CFLAGS}"
_CXXFLAGS="-I${_tools}/pkg/nspr-4.8/include/nspr -include unistd.h -include string.h -w ${pallur_CXXFLAGS}"
_LDFLAGS="-L${_tools}/pkg/nspr-4.8/lib ${pallur_LDFLAGS}"
_LIBS="${pallur_LIBS}"

echo "[ii] building..." >&2

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			CXXFLAGS="${_CXXFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	make -j 8 -f ./Makefile.ref \
			JS_DIST="${_tools}/pkg/js-1.8.0" \
			JS_THREADSAFE=1 \
			BUILD_OPT=1 \
			XCFLAGS="-DHAVE_VA_COPY -DVA_COPY=va_copy ${_CFLAGS}" \
			XCXXFLAGS="-DHAVE_VA_COPY -DVA_COPY=va_copy ${_CXXFLAGS}" \
			XLDFLAGS="${_LDFLAGS}"

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/js-1.8.0"
mkdir -- "${_tools}/pkg/js-1.8.0/lib"
mkdir -- "${_tools}/pkg/js-1.8.0/include"
mkdir -- "${_tools}/pkg/js-1.8.0/include/js"

find \
	. \
	./Linux_All_OPT.OBJ \
	-maxdepth 1 \
	\( -name '*.h' -o -name '*.tbl' \) \
	-exec cp -t "${_tools}/pkg/js-1.8.0/include/js" -- {} \;

cp -T -- ./Linux_All_OPT.OBJ/libjs.a "${_tools}/pkg/js-1.8.0/lib/libjs.a"
cp -T -- ./Linux_All_OPT.OBJ/libjs.so "${_tools}/pkg/js-1.8.0/lib/libjs.so"

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/js-1.8.0"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
