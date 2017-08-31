#!/bin/bash

. "$DOTPATH"/.zsh/20_functions.zsh

exclusion_dots=(. .. .git .gitignore .gvimrc .vsvimrc .tmux.remote.conf)
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
