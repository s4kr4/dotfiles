if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=~/.dotfiles; export DOTPATH
fi

export LANG=ja_JP.UTF-8
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export LANG="en_US.UTF-8"
export PATH=$PATH:$HOME/bin

if [[ is_osx ]]; then
	export PATH=$PATH:/usr/local/bin:/bin
fi

. "${DOTPATH}"/etc/lib/essential
. "${DOTPATH}"/.zsh/essential.zsh
. "${DOTPATH}"/.zsh_aliases
. "${DOTPATH}"/.zsh/env.zsh
. "${DOTPATH}"/.zsh/zplug.zsh

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


# --------------------------------------------------------------------
#  Completion settings
# --------------------------------------------------------------------

autoload predict-on
#predict-on

# Hilight ls command
export LS_COLORS='no=00:fi=00:di=01;36:ln=36:pi=31:so=33:bd=44;37:cd=44;37:ex=01;32:mi=00:or=36'
export LSCOLORS=gxfxcxdxbxegedabagacad
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Ignore upper/lower cases
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Set separator between lists and descriptions
zstyle ':completion:*' list-separator '-->'

# Suggest typoed commands
setopt correct

# Pack lists
setopt list_packed

# Enable complete for arguments
setopt magic_equal_subst

# Enable brace expansion
setopt brace_ccl


# --------------------------------------------------------------------
#  Delimiter
# --------------------------------------------------------------------

autoload -Uz select-word-style
select-word-style default 

# Set delimiter characters
zstyle ':zle:*' word-chars ' /=;@:{}[]()<>,|.'
zstyle ':zle:*' word-style unspecified


# --------------------------------------------------------------------
#  Command history
# --------------------------------------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
#setopt share_history


# --------------------------------------------------------------------
#  Make cd useful
# --------------------------------------------------------------------

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups


# --------------------------------------------------------------------
#  Others
# --------------------------------------------------------------------

# Suppress alert
setopt no_beep

# To enable keymap 'Ctrl+q' on Vim
stty -ixon


# --------------------------------------------------------------------
#  Key binds
# --------------------------------------------------------------------

bindkey -d
bindkey -v

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^N' down-line-or-history
bindkey '^P' up-line-or-history



# Start TMUX
if has tmux; then
    tmuxx
fi

