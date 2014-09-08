#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

for _task in requisites prepare compile package publish ; do
	cat <<EOS

mosaic-distribution : mosaic-distribution@${_task}

EOS
done

exit 0
