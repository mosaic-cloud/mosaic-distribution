#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`erlang\` (OTP / Erlang)..." >&2

if test -e "${_tools}/pkg/erlang" ; then
	echo "[ii] \`erlang\` already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/erlang\`)" >&2
	exit 0
fi

_outputs="${_temporary}/erlang--build"
_repository="${_dependencies}/otp/r15b03-1"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
cd -- "${_outputs}"

_CFLAGS="${pallur_CFLAGS}"
_LDFLAGS="${pallur_LDFLAGS}"
_LIBS="${pallur_LIBS}"

echo "[ii] building..." >&2

(
	export PATH="${_PATH}" CFLAGS="${_CFLAGS}" LDFLAGS="${_LDFLAGS}" LIBS="${_LIBS}"
	./configure --prefix="${_tools}/pkg/erlang" || exit 1
	make -j 8 || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/erlang"

(
	export PATH="${_PATH}"
	make install || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

ln -s -T -- "${_tools}/pkg/erlang/lib/erlang/usr" "${_tools}/pkg/erlang/usr"

find -H "${_tools}/pkg/erlang/bin" -xtype f -executable \
		-exec ln -s -t "${_tools}/bin" {} \;

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
