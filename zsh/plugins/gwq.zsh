if ! command -v gwq &> /dev/null; then
    return
fi

source <(gwq completion zsh)
