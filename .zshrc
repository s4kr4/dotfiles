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

color_end="%{[0m%}"
case ${UID} in
	# root
	0)
		PROMPT_USER="%{[38;5;196m%}%n${color_end}"
		;;

	# other
	*)
		PROMPT_USER="%{[38;5;046m%}%n${color_end}"
		;;

esac

if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
	# remote connection
	PROMPT_PATH="%{[38;5;202m%}%m:%(5~,.../%3~,%~)${color_end}"
else
	# local
	PROMPT_PATH="%{[38;5;045m%}%m:%(5~,.../%3~,%~)${color_end}"
fi

PROMPT="${PROMPT_USER}@${PROMPT_PATH} > "
RPROMPT="%{[38;5;242m%}%y [%D{%m/%d} %*]${color_end}"
PROMPT2="%_%% "


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
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{a-z}={A-Z}'

# Complete PID for killing
zstyle ':completion:*:processes' menu yes select=2

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

autoload -Uz add-zsh-hook

add-zsh-hook preexec complete_action


# --------------------------------------------------------------------
#  Key binds
# --------------------------------------------------------------------

bindkey -d
bindkey -v

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^N' down-line-or-history
bindkey '^P' up-line-or-history

bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^B' backward-char
bindkey -M viins '^F' forward-char

# Start TMUX
if has tmux; then
    tmuxx
fi

