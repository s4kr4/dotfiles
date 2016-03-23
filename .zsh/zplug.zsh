
zplug "b4b4r07/zplug"

zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "b4b4r07/enhancd"

zplug "b4b4r07/http_code"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

