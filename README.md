# dotfiles

Homebrew で管理する dotfiles

## 概要

- **Homebrew**: クロスプラットフォームのパッケージ管理
- **シンボリンク**: dotfiles の配置
- Linux / macOS 両対応

## ディレクトリ構成

```
~/.dotfiles/
├── Brewfile               # パッケージ一覧
├── Makefile               # インストールコマンド群
├── install.sh             # インストールスクリプト
├── scripts/
│   ├── install-brew.sh    # Homebrew インストール
│   └── deploy.sh          # シンボリンク作成
├── zsh/
│   ├── init/              # 基本設定 (env, aliases, functions, visual)
│   └── plugins/           # ツール別設定 (fzf, eza, enhancd, gwq)
├── nvim/                  # Neovim 設定
└── bin/                   # カスタムスクリプト
```

## インストール

```bash
git clone https://github.com/s4kr4/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

自動的に zsh が起動します。

### 手動インストール

```bash
make install    # Homebrew + dotfiles
make brew       # Homebrew のみ
make deploy     # シンボリンクのみ
```

## 含まれるツール

### CLI

| ツール | 説明 |
|--------|------|
| bat | cat の代替（シンタックスハイライト） |
| eza | ls の代替（モダンな表示） |
| fd | find の代替（高速） |
| fzf | ファジーファインダー |
| ripgrep | grep の代替（高速） |
| ghq | Git リポジトリ管理 |
| gwq | Git worktree 管理 |
| gh | GitHub CLI |
| tig | Git TUI |
| jq | JSON 処理 |
| mise | ランタイムバージョン管理 |

### Zsh プラグイン

| プラグイン | 説明 |
|------------|------|
| zsh-autosuggestions | コマンド補完候補の表示 |
| zsh-syntax-highlighting | シンタックスハイライト |
| enhancd | cd 拡張（履歴 + fzf） |

### エディタ

- Neovim（lazy.nvim でプラグイン管理）

## カスタマイズ

### パッケージの追加

`Brewfile` を編集：

```ruby
brew "package-name"
```

適用：

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

### エイリアスの追加

`zsh/init/30_aliases.zsh` を編集

### ツール設定の追加

`zsh/plugins/` に `tool-name.zsh` を作成：

```bash
if ! command -v tool-name &> /dev/null; then
    return
fi

# 設定
export TOOL_OPTION="value"
alias t="tool-name"
```

## 更新

```bash
cd ~/.dotfiles
make update
```

## ライセンス

MIT
