#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`erlang-17\` (OTP / Erlang)..." >&2

if test -e "${_tools}/pkg/erlang-17" ; then
	echo "[ii] \`erlang-17\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/erlang-17\`)" >&2
	exit 0
fi

_outputs="${_temporary}/erlang-17--build"
_repository="${_dependencies}/otp/17.1"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
chmod -R a=rX,u=rwX -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="${pallur_CFLAGS}"
_LDFLAGS="${pallur_LDFLAGS}"
_LIBS="${pallur_LIBS}"

_configure_arguments=(
		--disable-hipe
		--enable-m32-build
		--enable-dynamic-ssl-lib
		--disable-builtin-zlib
		--without-wx
		--without-odbc
		--without-javac
)

echo "[ii] building..." >&2

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	./configure \
			--prefix="${_tools}/pkg/erlang-17" \
			"${_configure_arguments[@]}"

_do_exec env \
			CFLAGS="${_CFLAGS}" \
			LDFLAGS="${_LDFLAGS}" \
			LIBS="${_LIBS}" \
	make -j 8

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/erlang-17"

_do_exec \
	make install

ln -s -T -- "${_tools}/pkg/erlang-17/lib/erlang/usr" "${_tools}/pkg/erlang-17/usr"

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/erlang-17"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
