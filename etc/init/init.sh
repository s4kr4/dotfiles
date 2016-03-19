#!/bin/bash

. "$DOTPATH"/essential

if [ -z "$DOTPATH" ]; then
	echo "$DOTPATH is not set" >&2
	exit 1
fi

sudo -v

#while true; do
#	sudo -n true
#	sleep 60;
#	kill -0 "$$" || exit
#done 2>/dev/null &

for f in "$DOTPATH"/etc/init/"$(get_os)"/*.sh; do
	if [ -f "$f" ]; then
		log_info "$(e_arrow "$(basename "$i")")"
		bash "$i"
	else
		continue
	fi
done

