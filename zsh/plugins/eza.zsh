if ! command -v eza &> /dev/null; then
    return
fi

alias l='eza --group-directories-first -a -1 -F --git-ignore'
alias lt='eza --group-directories-first -T --git-ignore --level 10'
alias lta='eza --group-directories-first -a -T --git-ignore --level 10 --ignore-glob .git'
alias la='eza --group-directories-first -a --header --git'
alias ll='eza --group-directories-first -l --header --git'
alias lla='eza --group-directories-first -la --header --git'
alias ls='eza --group-directories-first'
