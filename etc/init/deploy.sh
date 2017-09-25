#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

exclusion_dots=(. .. .git .gitignore .gvimrc .vsvimrc .tmux.conf .tmux.remote.conf)
inclusion_dirs=(bin)

log_info "Make symbolic links"

for f in "$DOTPATH"/.*; do
    if [ -f "$f" ] || [ -d "$f" ]; then
        if [[ ! " ${exclusion_dots[@]} " =~ " ${f##*/} " ]]; then
            log_echo "${f##*/}"
            ln -sfnv "$f" "$HOME/${f##*/}"
        fi
    fi
done

for f in "$DOTPATH"/*; do
    if [ -d "$f" ]; then
        if [[ " ${inclusion_dirs[@]} " =~ " ${f##*/} " ]]; then
            log_echo "${f##*/}"
            ln -sfnv "$f" "$HOME/${f##*/}"
        fi
    fi
done

if is_ssh_running; then
    ln -sfnv "$DOTPATH/.tmux.remote.conf" "$HOME/.tmux.conf"
else
    ln -sfnv "$DOTPATH/.tmux.conf" "$HOME/.tmux.conf"
fi
