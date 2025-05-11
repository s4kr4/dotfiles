. "$DOTPATH"/etc/lib/util.zsh

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export LANG="en_US.UTF-8"
export PATH=$PATH:$HOME/bin

export LOCAL_BIN_PATH="${HOME}/.local/bin"
export LOCAL_ENV_PATH="${HOME}/.local/env.zsh"

export AFX_BIN_DIR="${LOCAL_BIN_PATH}"
export AFX_COMMAND_PATH="${LOCAL_BIN_PATH}"

if is_osx; then
    export PATH=$PATH:/usr/local/bin:/bin
fi

# Deploy local settings
if [[ -e ${LOCAL_BIN_PATH} ]]; then
    mkdir -p ${LOCAL_BIN_PATH}
    PATH="${LOCAL_BIN_PATH}:$PATH"
fi
if [[ -e ${LOCAL_ENV_PATH} ]]; then
    source ${LOCAL_ENV_PATH}
fi

