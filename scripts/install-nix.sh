#!/bin/bash
set -e

echo "==> Checking Nix installation..."

if command -v nix &> /dev/null; then
    echo "Nix is already installed: $(nix --version)"
    exit 0
fi

echo "==> Installing Nix (Determinate Systems installer)..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

echo "==> Nix installed successfully!"
echo ""
echo "Please run the following command or restart your shell:"
echo "  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
