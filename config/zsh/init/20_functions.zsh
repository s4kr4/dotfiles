. "$DOTPATH"/etc/lib/util.zsh

dotfiles_download() {
    if [ -d "$DOTPATH" ]; then
        log_fail "$DOTPATH: already exists"
        exit 1
    fi

    e_newline
    e_header "Downloading dotfiles..."

    if has "git"; then
        git clone "$DOTFILES_GITHUB" "$DOTPATH"
    elif has "curl" || has "wget"; then
        tarball="https://github.com/s4kr4/dotfiles/archive/master.tar.gz"

        if has "curl"; then
            curl -L "$tarball"
        elif has "wget"; then
            wget -O - "$tarball"
        fi | tar xvz

        if [ ! -d dotfiles-master ]; then
            log_fail "dotfiles-master: not found"
            exit 1
        fi

        mv -f dotfiles-master "$DOTPATH"
    else
        log_fail "ERROR: require curl or wget"
        exit 1
    fi

    e_newline
    e_done "Download"
}

dotfiles_deploy() {
    e_newline
    e_header "Deploying dotfiles..."

    if [ ! -d $DOTPATH ]; then
        log_fail "$DOTPATH: not found"
        exit 1
    fi

    cd $DOTPATH

    make deploy &&
        e_newline && e_done "Deploy"
}

dotfiles_initialize() {
    if [ "$1" = "init" ]; then
        e_newline
        e_header "Initialize dotfiles..."

        if [ -f Makefile ]; then
            make init
        else
            log_fail "Makefile: not found"
            exit 1
        fi &&
            e_newline && e_done "Initialize"
    fi
}

dotfiles_install() {
    dotfiles_download &&
    dotfiles_deploy &&
    dotfiles_initialize "$@"
}

mkcd() {
    mkdir -p "$1"
    [ $? -eq 0 ] && cd "$1"
}

cmd_history() {
    if has fzf; then
        local tac
        if which tac > /dev/null; then
            tac="tac"
        else
            tac="tail -r"
        fi
        BUFFER=$(fc -l -n 1 | eval $tac | fzf)
        print -nP "${PROMPT//[$'\n\r']/}"
        CURSOR=${#BUFFER}
    fi
}
zle -N cmd_history

# gwq add -t: worktree 作成後に tmux セッションを作成・切り替え
gwq() {
    if ! has gwq; then
        echo "gwq: command not found" >&2
        return 127
    fi

    # add サブコマンド以外はそのまま実行
    if [[ "$1" != "add" ]]; then
        command gwq "$@"
        return $?
    fi

    # -t/--tmux オプションの検出と除去
    local use_tmux=false
    local -a args=()
    shift  # "add" を除去

    for arg in "$@"; do
        case "$arg" in
            -t|--tmux)
                use_tmux=true
                ;;
            -*)
                # -tb のような連結オプションから t を除去
                if [[ "$arg" =~ ^-[^-]*t ]]; then
                    use_tmux=true
                    local new_arg="${arg//t/}"
                    # -t のみだった場合は追加しない
                    [[ "$new_arg" != "-" ]] && args+=("$new_arg")
                else
                    args+=("$arg")
                fi
                ;;
            *)
                args+=("$arg")
                ;;
        esac
    done

    # -t なしの場合はそのまま実行
    if [[ "$use_tmux" == "false" ]]; then
        command gwq add "$@"
        return $?
    fi

    # gwq add を実行（-t を除去した引数で）
    command gwq add "${args[@]}"
    local gwq_status=$?

    if [[ $gwq_status -ne 0 ]]; then
        return $gwq_status
    fi

    # tmux/jq の存在チェック
    if ! has tmux; then
        return 0
    fi
    if ! has jq; then
        echo "Warning: jq is required for tmux session creation" >&2
        return 0
    fi

    # 最新の worktree パスを取得
    local worktree_path
    worktree_path=$(command gwq list --json | jq -r 'sort_by(.created_at) | last | .path // empty')

    if [[ -z "$worktree_path" ]] || [[ ! -d "$worktree_path" ]]; then
        echo "Warning: Failed to determine worktree directory" >&2
        return 0
    fi

    # セッション名を生成（ディレクトリ名から、. を _ に置換）
    local session_name
    session_name=$(basename "$worktree_path" | tr '.' '_')

    # tmux セッションを作成・切り替え
    if is_tmux_running; then
        if ! tmux has-session -t "$session_name" 2>/dev/null; then
            tmux new-session -d -s "$session_name" -c "$worktree_path"
        fi
        tmux switch-client -t "$session_name"
    else
        tmux new-session -As "$session_name" -c "$worktree_path"
    fi
}
