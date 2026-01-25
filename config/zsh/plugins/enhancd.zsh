ENHANCD_DIR="$HOME/.local/share/enhancd"

if [[ ! -f "$ENHANCD_DIR/init.sh" ]]; then
    return
fi

export ENHANCD_FILTER='fzf --preview "eza -al --tree --level 1 --group-directories-first --git-ignore --header --git --no-user --no-time --no-filesize --no-permissions {}" --preview-window right,50% --height 35% --reverse --ansi'

source "$ENHANCD_DIR/init.sh"
