#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


if test ! -e "${_tools}/.prepared" ; then
	
	echo "[ii] preparing tools..." >&2
	
	if test ! -e "${_tools}" ; then
		mkdir -- "${_tools}"
		mkdir -- "${_tools}/bin"
		mkdir -- "${_tools}/lib"
		mkdir -- "${_tools}/include"
		mkdir -- "${_tools}/pkg"
		mkdir -- "${_tools}/home"
	fi
	
	case "${_distribution_local_os}" in
		
		( mos::0.8 )
			
			echo "[ii] preparing \`mos\` environment..." >&2
			
			. "${_scripts}/prepare-tools-env-mos.bash"
			
			if test "${UID}" -eq 0 ; then
				
				tazpkg recharge
				yes | tazpkg upgrade
				
				for _dependency in "${_distribution_mos_dependencies[@]}" ; do
					tazpkg get-install "${_dependency}"
				done
				
			else
				echo "[ww] running without root priviledges; skipping!" >&2
			fi
			
			if test ! -e "${_tools}/pkg/erlang" -a ! -L "${_tools}/pkg/erlang" ; then
				ln -s -T -- /opt/mosaic-erlang-r15b01/lib/erlang "${_tools}/pkg/erlang"
			fi
			
			if test ! -e "${_tools}/pkg/nodejs" -a ! -L "${_tools}/pkg/nodejs" ; then
				ln -s -T -- /opt/mosaic-nodejs-0.8.4/lib/nodejs "${_tools}/pkg/nodejs"
			fi
			
			if test ! -e "${_tools}/pkg/java" -a ! -L "${_tools}/pkg/java" ; then
				ln -s -T -- /opt/jdk1.7.0_01 "${_tools}/pkg/java"
			fi
			
			if test ! -e "${_tools}/pkg/python" -a ! -L "${_tools}/pkg/python" ; then
				mkdir -- "${_tools}/pkg/python"
				mkdir -- "${_tools}/pkg/python/bin"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python2.7"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python2"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python"
			fi
		;;
		
		( archlinux::rolling )
			
			echo "[ii] preparing \`archlinux\` environment..." >&2
			
			. "${_scripts}/prepare-tools-env-archlinux.bash"
			
			if test "${UID}" -eq 0 ; then
				
				pacman -Sy --noconfirm
				pacman -Su --noconfirm
				
				for _dependency in "${_distribution_archlinux_dependencies[@]}" ; do
					pacman -S --noconfirm --needed "${_dependency}"
				done
				
			else
				echo "[ww] running without root priviledges; skipping!" >&2
			fi
			
			if test ! -e "${_tools}/pkg/java" -o ! -L "${_tools}/pkg/java" ; then
				ln -s -T -- /opt/java "${_tools}/pkg/java"
			fi
			
			if test ! -e "${_tools}/pkg/python" -a ! -L "${_tools}/pkg/python" ; then
				mkdir -- "${_tools}/pkg/python"
				mkdir -- "${_tools}/pkg/python/bin"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python2.7"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python2"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python"
			fi
		;;
		
		( ubuntu::12.04 )
			
			echo "[ii] preparing \`ubuntu\` environment..." >&2
			
			. "${_scripts}/prepare-tools-env-ubuntu.bash"
			
			if test "${UID}" -eq 0 ; then
				
				apt-get update -y
				yes | apt-get upgrade -y
				
				for _dependency in "${_distribution_ubuntu_dependencies[@]}" ; do
					yes | apt-get install -y "${_dependency}"
				done
				
			else
				echo "[ww] running without root priviledges; skipping!" >&2
			fi
			
			if test ! -e "${_tools}/pkg/java" -a ! -L "${_tools}/pkg/java" ; then
				ln -s -T -- /opt/jdk1.7.0_01 "${_tools}/pkg/java"
			fi
			
			if test ! -e "${_tools}/pkg/python" -a ! -L "${_tools}/pkg/python" ; then
				mkdir -- "${_tools}/pkg/python"
				mkdir -- "${_tools}/pkg/python/bin"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python2.7"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python2"
				ln -s -T -- /usr/bin/python2.7 "${_tools}/pkg/python/bin/python"
			fi
		;;
		
		( unknown::* )
			echo "[ww] unknown local OS \`${_distribution_local_os}\`; proceeding!" >&2
			exit 1
		;;
		
		( * )
			echo "[ee] invalid local OS \`${_distribution_local_os}\`; aborting!" >&2
			exit 1
		;;
		
	esac
	
	for _package in erlang nodejs java python ; do
		if test ! -e "${_tools}/pkg/${_package}/bin" ; then
			continue
		fi
		find -H "${_tools}/pkg/${_package}/bin" \
			-xtype f -executable \
			-exec ln -s -t "${_tools}/bin" {} \;
	done
	
	touch "${_tools}/.prepared"
fi


exit 0
