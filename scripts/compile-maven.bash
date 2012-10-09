#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

echo "[ii] preparing \`mvn\` (Maven)..." >&2

if test -e "${_tools}/pkg/mvn" ; then
	echo "[ii] \`mvn\` package already exists; aborting!" >&2
	echo "[ii] (to force the build remove the folder \`${_tools}/pkg/mvn\`)" >&2
	exit 0
fi

echo "[ii] fetching..." >&2

mkdir -- "${_tools}/pkg/mvn"

curl -s 'http://www.eu.apache.org/dist/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz' \
| tar -xz -C "${_tools}/pkg/mvn" --strip-components 1

echo "[ii] deploying..." >&2

ln -s -T -- "${_tools}/pkg/mvn/bin/mvn" "${_tools}/bin/mvn"

echo "[ii] preparing..." >&2

"${_tools}/bin/mvn" --quiet help:help

exit 0
