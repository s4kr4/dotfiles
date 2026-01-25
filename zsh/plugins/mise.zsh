# mise (runtime version manager)
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
elif [[ -x "$HOME/.local/bin/mise" ]]; then
    eval "$($HOME/.local/bin/mise activate zsh)"
fi
