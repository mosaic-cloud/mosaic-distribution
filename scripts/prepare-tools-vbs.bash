#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`vbs\` (Volution Build System)..." >&2

if test -e "${_tools}/bin/vbs" ; then
	echo "[ii] \`vbs\` executable already exists; aborting!" >&2
	echo "[ii] (to force the build remove the file \`${_tools}/bin/vbs\`)" >&2
	exit 0
fi

_outputs="${_temporary}/volution-build-system--build"
_repository="${_repositories}/volution-build-system"

echo "[ii] preparing..." >&2

mkdir -- "${_outputs}"
cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
cd -- "${_outputs}"

echo "[ii] building..." >&2

(
	export PATH="${_PATH}"
	./scripts/make-mk.bash || exit 1
	./scripts/make-chicken.bash || exit 1
	./scripts/make.bash || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

echo "[ii] deploying..." >&2

cp -T -- "./.outputs/vbs.elf" "${_tools}/bin/vbs"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
