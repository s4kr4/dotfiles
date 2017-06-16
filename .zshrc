if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=~/.dotfiles; export DOTPATH
fi

# Load config files
for file in "${DOTPATH}"/.zsh/*.zsh; do
	. "$file"
done


# Start TMUX
if has tmux; then
    tmuxx
fi

