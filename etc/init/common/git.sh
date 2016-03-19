#!/bin/bash

. "$DOTPATH"/etc/lib/essential

if ! has "git"; then
	case "$(get_os)" in
		osx)
			exit 1
			;;

		linux)
			install git
			if [ "$?" -eq 1 ]; then
				exit 1
			fi
			;;

		*)
			log_fail "ERROR: This script is only supported OSX or Linux"
			exit 1
			;;
	esac

	log_pass "git: Installed git successfully"
else
	log_pass "git: Already installed"
fi


