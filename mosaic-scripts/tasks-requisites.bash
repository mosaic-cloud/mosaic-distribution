#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_packages=(
		erlang-15
		erlang-17
		nodejs
		nodejs-caches
		go
		maven
		maven-caches
		zeromq
		jzmq
		jansson
		ninja
		vbs
)

_os_packages=(
		java
		python-2
		rpm
)

for _package in "${_packages[@]}" ; do
	cat <<EOS

pallur-packages : pallur-packages@{_package}

pallur-packages@${_package} : pallur-environment
	!bash ${_workbench}/mosaic-scripts/prepare-${_package}

EOS
done

for _package in "${_os_packages[@]}" ; do
	cat <<EOS

pallur-packages : pallur-package@${_package}

pallur-packages@{_package} : pallur-os

EOS
done

cat <<EOS

pallur-packages@jzmq : pallur-packages@zeromq
pallur-packages@maven : pallur-packages@maven-caches
pallur-packages@nodejs : pallur-packages@nodejs-caches

EOS

cat <<EOS

pallur-packages : pallur-os

pallur-os :
	#!bash ${_workbench}/mosaic-scripts/prepare-os

EOS

exit 0
