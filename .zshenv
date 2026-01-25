# zmodload zsh/zprof && zprof

# Homebrew
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export SHELL="/home/linuxbrew/.linuxbrew/bin/zsh"
elif [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export SHELL="/opt/homebrew/bin/zsh"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
    export SHELL="/usr/local/bin/zsh"
fi
