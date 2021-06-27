if [[ ! -e ~/.zplug/init.zsh ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug"

zplug "zsh-users/zsh-syntax-highlighting", \
    defer:2

zplug "b4b4r07/enhancd", \
    hook-load: "export ENHANCD_DIR='$XDG_CACHE_HOME/enhancd'"

zplug "b4b4r07/http_code"

zplug "junegunn/fzf", \
    from:gh-r, \
    as:command, \
    rename-to:fzf

zplug "BurntSushi/ripgrep", \
    from:gh-r, \
    as:command, \
    rename-to:rg

zplug "zsh-users/zsh-autosuggestions"

zplug "stedolan/jq", \
    from:gh-r, \
    as:command

if [[ $OSTYPE == *darwin* ]]; then
    zplug "github/hub", \
        from:gh-r, \
        as:command, \
        use:"*darwin*amd64*"
fi


# Then, source plugins and add commands to $PATH
zplug load

# Install plugins if there are plugins that have not been installed
zplug_check() {
    if ! zplug check --verbose; then
        printf "Install plugins? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
}

zplug_check

