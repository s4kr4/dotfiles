if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=~/.dotfiles; export DOTPATH
fi

if [ -z "${XDG_CONFIG_HOME:-}" ]; then
    XDG_CONFIG_HOME=~/.config; export XDG_CONFIG_HOME
fi

if [ -z "${XDG_CACHE_HOME:-}" ]; then
    XDG_CACHE_HOME=~/.cache; export XDG_CACHE_HOME
fi

# Load config files
for file in "${XDG_CONFIG_HOME}"/zsh/init/*.zsh; do
    . "$file"
done

# Load zplug only in tmux
# if [[ -n "$TMUX" ]]; then
#     . "${XDG_CONFIG_HOME}"/zsh/zplug.zsh
# fi

# Load axf
autoload -Uz compinit
compinit
. "${XDG_CONFIG_HOME}"/zsh/afx.zsh

# Load mise
. "${XDG_CONFIG_HOME}"/zsh/mise.zsh

# if (which zprof > /dev/null); then
#   zprof | less
# fi

# Start TMUX
if has tmux; then
    tmuxx
fi

