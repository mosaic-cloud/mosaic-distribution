#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

#echo "[ii] building \`vbs\` (Volution Build System)..." >&2

cd -- "${_repositories}/vbs"

if test -e "${_tools}/bin/vbs" ; then
	#echo "[ww] \`vbs\` executable already exists; aborting!" >&2
	#echo "[ww] (to force the build remove the file \`${_tools}/bin/vbs\`)" >&2
	exit 0
fi

#echo "[ii] building..." >&2

(
	export PATH="${_PATH}"
	./scripts/make-mk.bash || exit 1
	./scripts/make-chicken.bash || exit 1
	./scripts/make.bash || exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

#echo "[ii] deploying..." >&2

mkdir -p -- "${_tools}/bin"
cp -T -- "./.outputs/vbs.elf" "${_tools}/bin/vbs"

#echo "[ii] cleaning..." >&2

"${_git_bin}" reset -q --hard
"${_git_bin}" clean -q -f -d -x

exit 0
