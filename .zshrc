export LANG=ja_JP.UTF-8
export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
export PATH=$PATH:$HOME/bin
export LANG="en_US.UTF-8"

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

autoload -U compinit && compinit
zstyle ':completion:*' list-colors ''
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


if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=~/.dotfiles; export DOTPATH
fi

. "$DOTPATH"/etc/lib/essential
. "${DOTPATH}"/.zsh/essential.zsh
. "${DOTPATH}"/.zsh_aliases
. "${DOTPATH}"/.zplug/zplug
. "${DOTPATH}"/.zsh/zplug.zsh

tmuxx


