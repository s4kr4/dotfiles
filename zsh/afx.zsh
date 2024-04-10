. "$DOTPATH"/etc/lib/util.zsh

if ! has afx; then
    curl -sL https://raw.githubusercontent.com/b4b4r07/afx/HEAD/hack/install | bash
fi

source <(afx init)
source <(afx completion zsh)

