if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=~/.dotfiles; export DOTPATH
fi

# Load config files
for file in "${DOTPATH}"/.zsh/init/*.zsh; do
    . "$file"
done

# Load zplug only in tmux
if [[ -n "$TMUX" ]]; then
    . "${DOTPATH}"/.zsh/zplug.zsh
fi

# if (which zprof > /dev/null); then
#   zprof | less
# fi

# Start TMUX
if has tmux; then
    tmuxx
fi
