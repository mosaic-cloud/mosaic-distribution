#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

for _task in prepare compile package deploy ; do
	cat <<EOS

default@${_task} : mosaic-distribution@${_task}

EOS
done

exit 0
