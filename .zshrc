if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=~/.dotfiles; export DOTPATH
fi

if [ -z "${XDG_CONFIG_HOME:-}" ]; then
    XDG_CONFIG_HOME=~/.config; export XDG_CONFIG_HOME
fi

if [ -z "${XDG_CACHE_HOME:-}" ]; then
    XDG_CACHE_HOME=~/.cache; export XDG_CACHE_HOME
fi

# Load utility functions
. "$DOTPATH"/etc/lib/util.zsh

# Load init files
for file in "${XDG_CONFIG_HOME}"/zsh/init/*.zsh; do
    . "$file"
done

# compinit
autoload -Uz compinit
compinit

# Load plugin settings
for file in "${XDG_CONFIG_HOME}"/zsh/plugins/*.zsh; do
    [[ -f "$file" ]] && source "$file"
done

# Start TMUX
if has tmux; then
    tmuxx
fi
