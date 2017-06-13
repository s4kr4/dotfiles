# has_command returns true if $1 as a shell command exists
has.command() {
    (( $+commands[${1:?too few argument}] ))
    return $status
}

# has_command returns true if $1 as a shell function exists
has.function() {
    (( $+functions[${1:?too few argument}] ))
    return $status
}

# has_command returns true if $1 as a builtin command exists
has.builtin() {
    (( $+builtins[${1:?too few argument}] ))
    return $status
}

# has_command returns true if $1 as an alias exists
has.alias() {
    (( $+aliases[${1:?too few argument}] ))
    return $status
}

# has_command returns true if $1 as an alias exists
has.galias() {
    (( $+galiases[${1:?too few argument}] ))
    return $status
}

# has returns true if $1 exists
has() {
    has.function "$1" || \
        has.command "$1" || \
        has.builtin "$1" || \
        has.alias "$1" || \
        has.galias "$1"

    return $status
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

