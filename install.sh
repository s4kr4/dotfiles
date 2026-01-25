#!/bin/bash
set -e

cd "$(dirname "$0")"

make install

# Start zsh automatically
if [[ -f /home/linuxbrew/.linuxbrew/bin/zsh ]]; then
    exec /home/linuxbrew/.linuxbrew/bin/zsh -l
elif [[ -f /opt/homebrew/bin/zsh ]]; then
    exec /opt/homebrew/bin/zsh -l
elif command -v zsh &> /dev/null; then
    exec zsh -l
fi
