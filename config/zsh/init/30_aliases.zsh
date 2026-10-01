alias q='exit'
alias crontab='crontab -i'

case "${OSTYPE}" in
darwin*)
    alias ls='ls -G'
    ;;
*)
    alias ls='ls --color=auto'
    ;;
esac

alias lr='ls -R'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rm='rm -v'
alias rr='rm -r'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias df='df -h'

alias zmv='noglob zmv -W'

if is_cygwin; then
    alias open='cygstart'
fi

if has 'tmux'; then
    alias tmux='tmux -2'
    alias tmls='tmux ls'
    alias tmat='tmux a -t'
    alias tmns='tmux new-session -s'
fi

if has 'vim'; then
    alias v='vim'
    alias vi='vim'
fi

if has 'nvim'; then
    alias n='nvim'
fi

if has 'git'; then
    alias ga='git add'
    alias gaa='git add -A'
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gp='git push'
    alias gs='git status'
    alias gd='git diff'
    alias gco='git checkout'
    alias gcb='git checkout $(git branch | cut -c 3- | fzf)'
fi

if has 'ghq'; then
    # 旧定義の alias cwd が残るシェルで再 source すると、alias が関数より優先されて
    # 新しい定義が使われないため、先に外す
    (( ${+aliases[cwd]} )) && unalias cwd
    function cwd {
        local root selected
        root=$(ghq root) || return
        selected=$(ghq list | fzf)
        # fzf のキャンセル・マッチなしでは選択が空になるため、移動しない
        [[ -n $selected ]] || return 0
        cd -- "$root/$selected"
    }
fi

if has 'lxterminal'; then
    alias lxterminal='lxterminal --geometry=100x35'
fi

if [[ -e ${HOME}/.local/aliases.zsh ]]; then
    source ${HOME}/.local/aliases.zsh
fi

