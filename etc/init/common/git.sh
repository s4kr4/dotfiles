#!/bin/bash

. "$DOTPATH"/essential

if ! has "git"; then
	case "$(get_os)" in
		osx)
			exit 1
			;;

		linux)
			if has "yum"; then
				log_echo "Install git with Yellowdog Updater Modified"
				sudo yum -y install git
			elif "port"; then
				log_echo "Install git with Advanced Packaging Tool"
				sudo apt-get -y install git
			else
				log_fail "ERROR: require yum or apt"
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


