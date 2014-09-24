#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] building \`vbs\` (Volution Build System)..." >&2

if test -e "${_tools}/pkg/vbs" ; then
	echo "[ii] \`vbs\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/vbs\`)" >&2
	exit 0
fi

_outputs="${_temporary}/volution-build-system--build"
_repository="${_repositories}/volution-build-system"

echo "[ii] preparing..." >&2

if test -e "${_outputs}" ; then
	rm -R -- "${_outputs}"
fi
mkdir -- "${_outputs}"

cd -- "${_repository}"
find . -not -name '.git' -print0 | cpio -p -0 --quiet -- "${_outputs}"
chmod -R a=rX,u=rwX -- "${_outputs}"
cd -- "${_outputs}"

echo "[ii] building..." >&2

_do_exec \
	./scripts/make-mk.bash

_do_exec \
	./scripts/make-chicken.bash

_do_exec env \
			vbs_mk_vbs_target="${_outputs}/vbs.elf" \
	./scripts/make.bash vbs_deploy

echo "[ii] deploying..." >&2

mkdir -- "${_tools}/pkg/vbs"
mkdir -- "${_tools}/pkg/vbs/bin"

cp -T -- "${_outputs}/vbs.elf" "${_tools}/pkg/vbs/bin/vbs"

echo "[ii] sealing..." >&2

chmod -R a=rX -- "${_tools}/pkg/vbs"

echo "[ii] cleaning..." >&2

rm -R -- "${_outputs}"

exit 0
