#!/bin/bash
set -euo pipefail

FALLBACK_VERSION="v0.1.1"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="gwq"

echo "[gwq] Checking if gwq is already installed..."

if command -v gwq > /dev/null 2>&1; then
    echo "[gwq] Already installed at $(command -v gwq). Skipping."
    exit 0
fi

# Detect OS
case "$(uname -s)" in
    Darwin)
        GWQ_OS="Darwin"
        ;;
    Linux)
        GWQ_OS="Linux"
        ;;
    *)
        echo "Unsupported platform: $(uname -s)"
        exit 1
        ;;
esac

# Detect architecture
case "$(uname -m)" in
    x86_64)
        GWQ_ARCH="x86_64"
        ;;
    aarch64 | arm64)
        GWQ_ARCH="arm64"
        ;;
    *)
        echo "Unsupported platform: $(uname -m)"
        exit 1
        ;;
esac

echo "[gwq] Detected platform: ${GWQ_OS}/${GWQ_ARCH}"

# Fetch latest version from GitHub API, fall back to fixed version on failure
echo "[gwq] Fetching latest version from GitHub API..."
VERSION="$(curl -fsSL --max-time 10 https://api.github.com/repos/d-kuro/gwq/releases/latest 2>/dev/null \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')" || true

if [ -z "$VERSION" ]; then
    echo "[gwq] GitHub API unavailable, falling back to ${FALLBACK_VERSION}."
    VERSION="$FALLBACK_VERSION"
else
    echo "[gwq] Latest version: ${VERSION}"
fi

DOWNLOAD_URL="https://github.com/d-kuro/gwq/releases/download/${VERSION}/gwq_${GWQ_OS}_${GWQ_ARCH}.tar.gz"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
TARBALL="${TMP_DIR}/gwq.tar.gz"

echo "[gwq] Downloading from ${DOWNLOAD_URL}..."
curl -fsSL "$DOWNLOAD_URL" -o "$TARBALL"

echo "[gwq] Extracting archive..."
tar -xzf "$TARBALL" -C "$TMP_DIR"

echo "[gwq] Installing to ${INSTALL_DIR}/${BINARY_NAME}..."
mkdir -p "$INSTALL_DIR"
install -m 755 "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"

echo "[gwq] Installation complete: ${INSTALL_DIR}/${BINARY_NAME}"
echo "[gwq] NOTE: Restart your shell or run 'source ~/.zshrc' to use gwq."
