#!/bin/bash
set -e

DOTPATH="${DOTPATH:-$HOME/.dotfiles}"

# Check locale
check_locale() {
    if locale -a 2>/dev/null | grep -q "en_US.utf8\|en_US.UTF-8"; then
        return 0
    fi
    return 1
}

setup_locale() {
    echo "==> Checking locale..."
    if check_locale; then
        echo "  Locale en_US.UTF-8 is available."
        return 0
    fi

    echo "  Locale en_US.UTF-8 is not available."

    # Try to generate locale if on Linux with sudo
    if [[ "$(uname -s)" == "Linux" ]] && command -v locale-gen &> /dev/null; then
        echo "  Attempting to generate locale..."
        if sudo locale-gen en_US.UTF-8 2>/dev/null; then
            echo "  Locale generated successfully."
            return 0
        fi
    fi

    # Prompt user
    echo ""
    echo "  WARNING: Locale en_US.UTF-8 is not configured."
    echo "  Some tools may show warnings. To fix, run:"
    echo ""
    echo "    sudo apt install -y locales"
    echo "    sudo locale-gen en_US.UTF-8"
    echo ""
}

setup_locale

echo "==> Deploying dotfiles..."

# Create symlinks
CONFIGIGNORE="$DOTPATH/.configignore"

# Check if a DOTPATH-relative path is listed in .configignore
is_ignored() {
    local rel="$1"

    if [[ ! -f "$CONFIGIGNORE" ]]; then
        return 1
    fi

    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim leading/trailing whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        [[ -z "$line" ]] && continue
        [[ "$line" == \#* ]] && continue

        if [[ "$line" == "$rel" ]]; then
            return 0
        fi
    done < "$CONFIGIGNORE"

    return 1
}

link_file() {
    local src="$1"
    local dst="$2"
    local rel="${src#$DOTPATH/}"

    if is_ignored "$rel"; then
        echo "  Skipped (ignored): $rel"
        return 0
    fi

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mv "$dst" "${dst}.backup"
        echo "  Backed up: $dst -> ${dst}.backup"
    fi

    ln -s "$src" "$dst"
    echo "  Linked: $dst -> $src"
}

# Home directory dotfiles
link_file "$DOTPATH/.zshrc" "$HOME/.zshrc"
link_file "$DOTPATH/.zshenv" "$HOME/.zshenv"
link_file "$DOTPATH/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTPATH/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTPATH/.vimrc" "$HOME/.vimrc"

# XDG config
mkdir -p "$HOME/.config"
link_file "$DOTPATH/config/zsh" "$HOME/.config/zsh"
link_file "$DOTPATH/config/nvim" "$HOME/.config/nvim"
link_file "$DOTPATH/config/vim" "$HOME/.config/vim"
link_file "$DOTPATH/config/gwq" "$HOME/.config/gwq"

# Custom scripts
link_file "$DOTPATH/bin" "$HOME/bin"

# Manually install enhancd (zsh plugin)
ENHANCD_DIR="$HOME/.local/share/enhancd"
if [[ ! -d "$ENHANCD_DIR" ]]; then
    echo "==> Installing enhancd..."
    git clone https://github.com/b4b4r07/enhancd.git "$ENHANCD_DIR"
fi

echo "==> Deploy complete!"
