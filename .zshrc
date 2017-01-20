if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=~/.dotfiles; export DOTPATH
fi

. "${DOTPATH}"/etc/lib/essential
. "${DOTPATH}"/.zsh/essential.zsh
. "${DOTPATH}"/.zsh_aliases
. "${DOTPATH}"/.zsh/env.zsh
. "${DOTPATH}"/.zsh/zplug.zsh

export LANG=ja_JP.UTF-8
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export LANG="en_US.UTF-8"
export PATH=$PATH:$HOME/bin

if [[ is_osx ]]; then
	export PATH=$PATH:/usr/local/bin:/bin
fi

case ${UID} in
	# root
	0)
		PROMPT="%{[38;5;202m%}%n%{[0m%}@%{[38;5;045m%}%m:%~%{[0m%} # "
		;;

	# other
	*)
		PROMPT="%{[38;5;046m%}%n%{[0m%}@%{[38;5;045m%}%m:%~%{[0m%} > "
		;;

esac

RPROMPT="%{[38;5;242m%}%y [%D{%m/%d} %*]%{[0m%}"
PROMPT2="%_%% "

autoload -Uz compinit
os_detect
if [ is_cygwin ]; then
	compinit -u
else
	compinit
fi

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-separator '-->'
autoload predict-on
#predict-on

autoload -Uz select-word-style
select-word-style default 
zstyle ':zle:*' word-chars ' /=;@:{}[]()<>,|.'
zstyle ':zle:*' word-style unspecified

setopt no_beep

# command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

setopt correct
setopt list_packed

bindkey -d
bindkey -e


if has tmux; then
    tmuxx
fi

