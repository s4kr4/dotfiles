export LANG=ja_JP.UTF-8

case ${UID} in
	0)
		PROMPT="%{[38;5;202m%}%n%{[0m%}@%{[38;5;045m%}%m:%~%{[0m%} # "
		;;

	*)
		PROMPT="%{[38;5;046m%}%n%{[0m%}@%{[38;5;045m%}%m:%~%{[0m%} > "
		;;

esac
RPROMPT="%{[38;5;242m%}%y [%D{%m/%d} %*]%{[0m%}"
PROMPT2="%_%% "

autoload -U compinit && compinit
zstyle ':completion:*' list-colors ''
autoload predict-on && predict-on

# command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

setopt auto_cd
setopt auto_pushd

setopt correct
setopt list_packed

# aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# zsh-syntax-highlighting
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


