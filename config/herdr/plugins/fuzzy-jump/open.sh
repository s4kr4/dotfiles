#!/usr/bin/env bash
# Keybinding entrypoint: herdr 0.7.3 keys cannot open plugin panes directly,
# so a plugin_action opens the overlay via the API instead.
set -euo pipefail
exec "${HERDR_BIN_PATH:-herdr}" plugin pane open \
    --plugin "${HERDR_PLUGIN_ID:-s4kr4.fuzzy-jump}" --entrypoint jump
