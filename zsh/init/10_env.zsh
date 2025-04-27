. "$DOTPATH"/etc/lib/util.zsh

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export LANG="en_US.UTF-8"
export PATH=$PATH:$HOME/bin
export FZF_DEFAULT_OPTS="--reverse --border --height 40%"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow"

if is_osx; then
    export PATH=$PATH:/usr/local/bin:/bin
fi

# asdf settings
if [[ -d ${HOME}/.asdf ]]; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# Deploy local settings
if [[ -e ${HOME}/.local/bin ]]; then
    mkdir -p ${HOME}/.local/bin
    PATH="$HOME/.local/bin:$PATH"
fi
if [[ -e ${HOME}/.local/env.zsh ]]; then
    source ${HOME}/.local/env.zsh
fi

export AFX_BIN_DIR="$HOME/.local/bin"

