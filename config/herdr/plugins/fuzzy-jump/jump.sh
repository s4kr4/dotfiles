#!/usr/bin/env bash
set -euo pipefail

# herdr server may run without the user's shell PATH (e.g. launchd)
PATH="${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}"

HERDR="${HERDR_BIN_PATH:-herdr}"

for cmd in fzf jq; do
    if ! command -v "$cmd" >/dev/null; then
        echo "fuzzy-jump: ${cmd} not found in PATH" >&2
        read -r -n 1 -p "Press any key to close..."
        exit 1
    fi
done

workspaces="$("$HERDR" workspace list | jq '.result.workspaces')"
tabs="$("$HERDR" tab list | jq '.result.tabs')"
panes="$("$HERDR" pane list | jq '.result.panes')"

# Candidate line: kind <TAB> target_id <TAB> tab_id <TAB> display...
candidates="$(jq -rn \
    --argjson ws "$workspaces" \
    --argjson tabs "$tabs" \
    --argjson panes "$panes" \
    --arg self "${HERDR_PANE_ID:-}" '
    ($ws | map({key: .workspace_id, value: .}) | from_entries) as $wsmap |
    ($tabs | map({key: .tab_id, value: .}) | from_entries) as $tabmap |
    def wslabel($id): $wsmap[$id].label // $id;
    def status: if .agent_status == "unknown" then "" else " [\(.agent_status)]" end;
    ($tabs[] |
        "tab\t\(.tab_id)\t\(.tab_id)\t[tab]  \(wslabel(.workspace_id)) > \(.label)\t(\(.pane_count) panes)\(status)"),
    ($panes[] | select(.pane_id != $self) |
        "pane\t\(.pane_id)\t\(.tab_id)\t[pane] \(wslabel(.workspace_id)) > \($tabmap[.tab_id].label // "?") > \(.pane_id | split(":")[1])\t\(if .agent then "\(.agent)" else "" end)\(status)  \(.cwd | sub("^\(env.HOME)"; "~"))")
')"

selected="$(fzf --delimiter '\t' --with-nth 4.. --prompt 'jump> ' \
    --height 100% --layout reverse --info inline <<<"$candidates")" || exit 0

kind="$(cut -f1 <<<"$selected")"
target_id="$(cut -f2 <<<"$selected")"
tab_id="$(cut -f3 <<<"$selected")"

# Focusing a tab also brings its workspace forward
"$HERDR" tab focus "$tab_id" >/dev/null

if [[ "$kind" == "pane" ]]; then
    # pane.focus is socket-API only (the CLI variant is direction-based)
    python3 - "$target_id" <<'PY'
import json, os, socket, sys

path = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser("~/.config/herdr/herdr.sock")
req = {"id": "fuzzy-jump", "method": "pane.focus", "params": {"pane_id": sys.argv[1]}}
s = socket.socket(socket.AF_UNIX)
s.connect(path)
s.sendall(json.dumps(req).encode() + b"\n")
buf = b""
while not buf.endswith(b"\n"):
    chunk = s.recv(65536)
    if not chunk:
        break
    buf += chunk
resp = json.loads(buf)
if "error" in resp:
    print(f"fuzzy-jump: {resp['error']['message']}", file=sys.stderr)
    sys.exit(1)
PY
fi
