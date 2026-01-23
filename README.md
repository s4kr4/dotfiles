# dotfiles

Nix + Home Manager + Flakes で管理する dotfiles

## 概要

- **Nix**: 再現性のあるパッケージ管理
- **Home Manager**: ユーザー環境（dotfiles含む）の宣言的管理
- **Flakes**: 依存関係のロックと再現性の確保

Linux / macOS の両方に対応。

## ディレクトリ構成

```
~/.dotfiles/
├── flake.nix              # エントリーポイント
├── flake.lock             # 依存関係のバージョンロック
├── nix/
│   └── home/
│       ├── default.nix    # Home Manager共通設定
│       ├── packages.nix   # パッケージ一覧
│       ├── git.nix        # Git設定
│       ├── tmux.nix       # Tmux設定
│       ├── zsh.nix        # Zsh設定
│       └── neovim.nix     # Neovim設定
├── nvim/                  # Neovim設定（lua）
├── bin/                   # カスタムスクリプト
└── zsh/                   # Zsh追加設定
```

## インストール

```bash
git clone https://github.com/s4kr4/dotfiles ~/.dotfiles
cd ~/.dotfiles
make install
```

これで以下が自動的に実行されます：

1. Nix のインストール（Determinate Systems installer）
2. Home Manager の適用（OS自動判定）

インストール完了後、シェルを再起動してください。

### 手動インストール

個別に実行する場合：

```bash
make nix          # Nixのみインストール
make home-manager # Home Managerの適用のみ
```

## 使い方

### 設定変更後の適用

```bash
cd ~/.dotfiles
home-manager switch --flake .#s4kr4@linux -b backup
```

### flake.lock の更新

```bash
nix flake update
```

### 世代管理

```bash
# 世代一覧
home-manager generations

# ロールバック（世代パスを指定）
/nix/store/xxx-home-manager-generation/activate
```

### Nix の開発シェル

```bash
# Nix LSP + フォーマッターが使える環境
nix develop
```

## 含まれるツール

### CLI

| ツール | 説明 |
|--------|------|
| bat | catの代替（シンタックスハイライト付き） |
| eza | lsの代替（モダンな表示） |
| fd | findの代替（高速） |
| fzf | ファジーファインダー |
| ripgrep | grepの代替（高速） |
| ghq | Gitリポジトリ管理 |
| gwq | Git worktree管理 |
| gh | GitHub CLI |
| tig | Git TUI |
| lazygit | Git TUI |
| jq | JSON処理 |

### Zsh プラグイン

- zsh-autosuggestions
- zsh-syntax-highlighting
- enhancd（cd拡張）
- fzf integration
- direnv + nix-direnv

### エディタ

- Neovim + LSP（lua-language-server, nil, typescript-language-server, pyright 等）

## カスタマイズ

### パッケージの追加

`nix/home/packages.nix` を編集：

```nix
home.packages = with pkgs; [
  # 追加したいパッケージ
  your-package
];
```

### エイリアスの追加

`nix/home/zsh.nix` の `shellAliases` を編集：

```nix
shellAliases = {
  myalias = "some-command";
};
```

### 新しいマシンの追加

`flake.nix` に新しい `homeConfigurations` を追加：

```nix
homeConfigurations = {
  "username@hostname" = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor "x86_64-linux";
    # ...
  };
};
```

## ライセンス

MIT
