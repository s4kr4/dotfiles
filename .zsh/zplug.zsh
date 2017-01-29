if [[ ! -e ~/.zplug/init.zsh ]]; then
	curl -sL zplug.sh/installer | zsh
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug"

zplug "zsh-users/zsh-syntax-highlighting", \
	defer:2

zplug "b4b4r07/enhancd", \
	use:init.sh

#zplug "hchbaw/auto-fu.zsh", \
#	at:pu

zplug "b4b4r07/http_code"

#zplug "peco/peco", \
#	as:command, \
#	from:gh-r

#zplug "junegunn/fzf-bin", \
#	as:command, \
#	from:gh-r, \
#	rename-to:fzf

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

