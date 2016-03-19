#!/bin/bash

. "$DOTPATH"/essential

if ! has "zsh"; then
	case "$(get_os)" in
		osx)
			exit 1
			;;

		linux)
			if has "yum"; then
				log_echo "Install zsh with Yellowdog Updater Modified"
				sudo yum -y install zsh
			elif "port"; then
				log_echo "Install zsh with Advanced Packaging Tool"
				sudo apt-get -y install zsh
			else
				log_fail "error: require: yum or apt"
				exit 1
			fi
			;;

		*)
			log_fail "error: This script is only supported OSX or Linux"
			exit 1
			;;
	esac
else
	log_pass "zsh: Already installed"
fi

# Assign zsh as a login shell
if ! contains "${SHELL:-}" "zsh"; then
	zsh_path="$(which zsh)"

	if ! grep -xq "${zsh_path:=/bin/zsh}" /etc/shells; then
		log_fail "You should append '$zsh_path' to /etc/shells"
		exit 1
	fi

	if [ -x "$zsh_path" ]; then
		if chsh -s "$zsh_path" "${USER:-root}"; then
			log_pass "Change shell to $zsh_path for ${USER:-root} successfully"
		else
			log_fail "Cannot set '$path' as \$SHELL"
			log_fail "Check with '$path' to be described in /etc/shells"
			exit 1
		fi

		if [ ${EUID:-${UID}} = 0 ]; then
			if chsh -s "$zsh_path" && :; then
				log_pass "Change shell to $zsh_path for root successfully"
			fi
		fi
	else
		log_fail "invalid path: $zsh_path"
		exit 1
	fi
fi

