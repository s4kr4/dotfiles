#!/bin/bash
set -e

HOST="${1:-linux}"
DOTPATH="${DOTPATH:-$HOME/.dotfiles}"
USERNAME="s4kr4"

echo "==> Applying Home Manager configuration for ${USERNAME}@${HOST}..."

# Nix環境を読み込む
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Nixが利用可能か確認
if ! command -v nix &> /dev/null; then
    echo "Error: Nix is not installed or not in PATH"
    echo "Please run 'make nix' first or restart your shell"
    exit 1
fi

cd "$DOTPATH"

# Home Managerが管理するパスの既存シンボリックリンクを削除
# （dotfilesリポジトリへのリンクがあるとHome Managerがそこに書き込んでしまうため）
echo "==> Removing existing symlinks that conflict with Home Manager..."
targets=(
    "$HOME/bin"
    "$HOME/.config/nvim"
    "$HOME/.config/zsh"
    "$HOME/.config/afx"
    "$HOME/.config/tmux"
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.gitconfig"
    "$HOME/.tigrc"
    "$HOME/.tmux.conf"
)

for target in "${targets[@]}"; do
    if [ -L "$target" ]; then
        echo "  Removing symlink: $target"
        rm "$target"
    fi
done

# 既存の設定ファイルをバックアップしながらHome Managerを適用
echo "==> Running home-manager switch..."
nix run nixpkgs#home-manager -- switch --flake ".#${USERNAME}@${HOST}" -b backup

echo ""
echo "==> Home Manager applied successfully!"
echo "Please restart your shell to use the new configuration."
