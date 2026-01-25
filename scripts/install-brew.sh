#!/bin/bash
set -e

DOTPATH="${DOTPATH:-$HOME/.dotfiles}"

echo "==> Checking Homebrew installation..."

if command -v brew &> /dev/null; then
    echo "Homebrew is already installed: $(brew --version | head -1)"
else
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for this session
    if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

echo "==> Installing packages from Brewfile..."
brew bundle --file="$DOTPATH/Brewfile"

echo "==> Homebrew setup complete!"
