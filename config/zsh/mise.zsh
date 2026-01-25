. "$DOTPATH"/etc/lib/util.zsh

# mise (optional - skip if not installed)
if has mise; then
    eval "$(mise activate zsh)"
elif [[ -x "$HOME/.local/bin/mise" ]]; then
    eval "$($HOME/.local/bin/mise activate zsh)"
fi
