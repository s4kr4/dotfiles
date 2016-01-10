export LANG=ja_JP.UTF-8
export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
export PATH=$PATH:$HOME/bin

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

# aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# zsh-syntax-highlighting
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# enhancd
if [ -f "/home/mana/.enhancd/zsh/enhancd.zsh" ]; then
    source "/home/mana/.enhancd/zsh/enhancd.zsh"
fi

# tmux
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
	if is_screen_or_tmux_running; then
		! is_exists 'tmux' && return 1

		if is_tmux_runnning; then
			if [ $UID -ne 0 ]; then
				echo "[38;5;160m _   _      _ _                               _     _   _ [0m"
				echo "[38;5;226m| | | | ___| | | ___      __      _____  _ __| | __| | | |[0m"
				echo "[38;5;046m| |_| |/ _ \ | |/ _ \     \ \ /\ / / _ \| '__| |/ _  | | |[0m"
				echo "[38;5;033m|  _  |  __/ | | (_) | _   \ V  V / (_) | |  | | (_| | |_|[0m"
				echo "[38;5;129m|_| |_|\___|_|_|\___/ | )   \_/\_/ \___/|_|  |_|\__,_| (_)[0m"
				echo "[38;5;129m                      |/                                  [0m"

				landscape-sysinfo --exclude-sysinfo-plugins=LandscapeLink
				echo ""
			fi
		elif is_screen_running; then
			echo "This is on screen."
		fi
	else
		if shell_has_started_interactively && ! is_ssh_running; then
			if ! is_exists 'tmux'; then
				echo 'Error: tmux command not found' 2>&1
				return 1
			fi
			
			if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
				# detached session exists
				tmux list-sessions
				echo -n "Tmux: attach? (y/N/num) "
				read
				if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
					tmux attach-session
					if [ $? -eq 0 ]; then
						echo "$(tmux -V) attached session"
						return 0
					fi
				elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
					tmux attach -t "$REPLY"
					if [ $? -eq 0 ]; then
						echo "$(tmux -V) attached session"
						return 0
					fi
				fi
			fi
			
			if is_osx && is_exists 'reattach-to-user-namespace'; then
				# on OS X force tmux's default command
				# to spawn a shell in the user's namespace
				tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
				tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
			else
				tmux new-session && echo "tmux created new session"
			fi
		fi
	fi
}
tmux_automatically_attach_session

