if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=~/.dotfiles; export DOTPATH
fi

is_exists()
{
	which "$1" >/dev/null 2>&1
	return $?
}

has()
{
	is_exists "$@"
}

# ostype returns the lowercase OS name
ostype() {
	# shellcheck disable=SC2119
	uname | lower
}

# os_detect export the PLATFORM variable as you see fit
os_detect() {
	export PLATFORM
	case "$(ostype)" in
		*'linux'*)  PLATFORM='linux'   ;;
		*'darwin'*) PLATFORM='osx'     ;;
		*'bsd'*)    PLATFORM='bsd'     ;;
		*'cygwin'*) PLATFORM='cygwin'  ;;
		*)          PLATFORM='unknown' ;;
	esac
}

# is_osx returns true if running OS is Macintosh
is_osx() {
	os_detect
	if [ "$PLATFORM" = "osx" ]; then
		return 0
	else
		return 1
	fi
}
alias is_mac=is_osx

# is_linux returns true if running OS is GNU/Linux
is_linux() {
	os_detect
	if [ "$PLATFORM" = "linux" ]; then
		return 0
	else
		return 1
	fi
}

# is_bsd returns true if running OS is FreeBSD
is_bsd() {
	os_detect
	if [ "$PLATFORM" = "bsd" ]; then
		return 0
	else
		return 1
	fi
}

# is_cygwin returns true if running OS is cygwin
is_cygwin() {
	os_detect
	if [ "$PLATFORM" = "cygwin" ]; then
		return 0
	else
		return 1
	fi
}

# get_os returns OS name of the platform that is running
get_os() {
	local os
	for os in osx linux bsd cygwin; do
		if is_$os; then
			echo $os
		fi
	done
}

# is_screen_running returns true if GNU screen is running
is_screen_running() {
    [ ! -z "$STY" ]
}

# is_tmux_runnning returns true if tmux is running
is_tmux_running() {
    [ ! -z "$TMUX" ]
}

# is_screen_or_tmux_running returns true if GNU screen or tmux is running
is_screen_or_tmux_running() {
    is_screen_running || is_tmux_running
}

shell_has_started_interactively() {
	[ ! -z "$PS1" ]
}

# is_ssh_running returns true if the ssh deamon is available
is_ssh_running() {
    [ ! -z "$SSH_CLIENT" ]
}

ink() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <color> <text>"
        echo "Colors:"
        echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
        return 1
    fi

    local open="\033["
    local close="${open}0m"
    local black="0;30m"
    local red="1;31m"
    local green="1;32m"
    local yellow="1;33m"
    local blue="1;34m"
    local purple="1;35m"
    local cyan="1;36m"
    local gray="0;37m"
    local white="$close"

    local text="$1"
    local color="$close"

    if [ "$#" -eq 2 ]; then
        text="$2"
        case "$1" in
            black | red | green | yellow | blue | purple | cyan | gray | white)
            eval color="\$$1"
            ;;
        esac
    fi

    printf "${open}${color}${text}${close}"
}

logging() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <fmt> <msg>"
        echo "Formatting Options:"
        echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
        return 1
    fi

    local color=
    local text="$2"

    case "$1" in
        TITLE)
            color=yellow
            ;;
        ERROR | WARN)
            color=red
            ;;
        INFO)
            color=blue
            ;;
        SUCCESS)
            color=green
            ;;
        *)
            text="$1"
    esac

    timestamp() {
        ink gray "["
        ink purple "$(date +%H:%M:%S)"
        ink gray "] "
    }

    timestamp; ink "$color" "$text"; echo
}

log_pass() {
    logging SUCCESS "$1"
}

log_fail() {
    logging ERROR "$1" 1>&2
}

log_fail() {
    logging WARN "$1"
}

log_info() {
    logging INFO "$1"
}

log_echo() {
    logging TITLE "$1"
}

e_newline() {
    printf "\n"
}

e_header() {
    printf " \033[37;1m%s\033[m\n" "$*"
}

e_error() {
    printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

e_warning() {
    printf " \033[31m%s\033[m\n" "$*"
}

e_done() {
    printf " \033[37;1m%s\033[m...\033[32mOK\033[m\n" "✔ $*"
}

e_arrow() {
    printf " \033[37;1m%s\033[m\n" "➜ $*"
}

e_indent() {
    for ((i=0; i<${1:-4}; i++)); do
        echon " "
    done
    if [ -n "$2" ]; then
        echo "$2"
    else
        cat <&0
    fi
}

e_success() {
    printf " \033[37;1m%s\033[m%s...\033[32mOK\033[m\n" "✔ " "$*"
}

e_failure() {
    die "${1:-$FUNCNAME}"
}

lower() {
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            echo "$1"
        fi
    else
        return 1
    fi | tr "[:upper:]" "[:lower:]"
}

upper() {
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            echo "$1"
        fi
    else
        return 1
    fi | tr "[:lower:]" "[:upper:]"
}

contains() {
    string="$1"
    substring="$2"
    if [ "${string#*$substring}" != "$string" ]; then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

install() {
	if has "yum"; then
		log_echo "Install ${1} with Yellowdog Updater Modified"
		sudo yum -y install "$1"
	elif has "apt-get"; then
		log_echo "Install ${1} with Advanced Packaging Tool"
		sudo apt-get -y install "$1"
	elif has "apt-cyg"; then
		log_echo "Install ${1} with Advanced Packaging Tool for Cygwin"
		apt-cyg install "$1"
	else
		log_fail "ERROR: require yum or apt"
		return 1
	fi
}

dotfiles_download() {
	if [ -d "$DOTPATH" ]; then
		log_fail "$DOTPATH: already exists"
		exit 1
	fi

	e_newline
	e_header "Downloading dotfiles..."

	if has "git"; then
		git clone "$DOTFILES_GITHUB" "$DOTPATH"
	elif has "curl" || has "wget"; then
		tarball="https://github.com/s4kr4/dotfiles/archive/master.tar.gz"

		if has "curl"; then
			curl -L "$tarball"
		elif has "wget"; then
			wget -O - "$tarball"
		fi | tar xvz

		if [ ! -d dotfiles-master ]; then
			log_fail "dotfiles-master: not found"
			exit 1
		fi

		mv -f dotfiles-master "$DOTPATH"
	else
		log_fail "ERROR: require curl or wget"
		exit 1
	fi

	e_newline
	e_done "Download"
}

dotfiles_deploy() {
	e_newline
	e_header "Deploying dotfiles..."

	if [ ! -d $DOTPATH ]; then
		log_fail "$DOTPATH: not found"
		exit 1
	fi

	cd $DOTPATH

	make deploy &&
		e_newline && e_done "Deploy"
}

dotfiles_initialize() {
	if [ "$1" = "init" ]; then
		e_newline
		e_header "Initialize dotfiles..."

		if [ -f Makefile ]; then
			make init
		else
			log_fail "Makefile: not found"
			exit 1
		fi &&
			e_newline && e_done "Initialize"
	fi
}

dotfiles_install() {
	dotfiles_download &&
	dotfiles_deploy &&
	dotfiles_initialize "$@"
}

mkcd() {
	mkdir -p "$1"
	[ $? -eq 0 ] && cd "$1"
}

complete_action() {
	if ! has "$0"; then
		suffix=(c config cpp cc cs conf html jade java js json jsx lock log md php pug py rb sh slim toml ts txt vim yml zsh babelrc bashrc eslintrc gvimrc vimrc zsh_aliases zsh_history zshrc)
		if [ -f "$1" ]; then
			if echo "${suffix[*]}" | grep -q "${1##*.}"; then
				if has vim; then
					vim "$1"
					return $?
				fi
			fi
		fi
		return 127
	fi
}

