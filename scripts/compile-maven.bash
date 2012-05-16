#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

#echo "[ii] building \`mvn\` (Maven)..." >&2

if test -e "${_tools}/pkg/mvn" ; then
	#echo "[ww] \`mvn\` package already exists; aborting!" >&2
	#echo "[ww] (to force the build remove the folder \`${_tools}/pkg/mvn\`)" >&2
	exit 0
fi

#echo "[ii] fetching and deploying..." >&2

(
	mkdir -p "${_tools}/pkg/mvn" || exit 1
	curl -s 'http://mirrors.hostingromania.ro/apache.org/maven/binaries/apache-maven-3.0.4-bin.tar.gz' \
	| tar -xz -C "${_tools}/pkg/mvn" --strip-components 1 \
	|| exit 1
	exit 0
) 2>&1 \
| sed -u -r -e 's!^.*$![  ] &!g' >&2

#echo "[ii] deploying..." >&2

mkdir -p -- "${_tools}/bin"
ln -s -T -- "${_tools}/pkg/mvn/bin/mvn" "${_tools}/bin/mvn"

#echo "[ii] preparing..." >&2

"${_tools}/bin/mvn" --quiet help:help

exit 0
