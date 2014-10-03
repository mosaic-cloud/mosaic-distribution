#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


if test -e "${_temporary}/tasks.txt" ; then
	exec cat -- "${_temporary}/tasks.txt"
fi

if test -e "${_temporary}" ; then
	exec 3>&1 >|"${_temporary}/tasks.txt.tmp"
fi


cat <<EOS

default : default@prepare default@compile default@package

EOS


while read -r _script ; do
	case "${_script}" in
		( *.bash )
			if test -x "${_script}" ; then
				_do_exec1 "${_script}"
			else
				_do_bash1 "${_script}"
			fi
		;;
		( * )
			if test -x "${_script}" ; then
				_do_exec1 "${_script}"
			else
				false
			fi
		;;
	esac
done < <( find "${_workbench}/distribution-tasks" -xtype f -print | sort )


if test -e "${_temporary}/tasks.txt.tmp" ; then
	mv -T -- "${_temporary}/tasks.txt.tmp" "${_temporary}/tasks.txt"
	exec cat -- "${_temporary}/tasks.txt" >&3
	exit 1
fi

exit 0
