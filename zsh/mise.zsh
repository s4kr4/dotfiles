. "$DOTPATH"/etc/lib/util.zsh

if ! has mise; then
    curl https://mise.run | sh
fi

eval "$(~/.local/bin/mise activate zsh)"

