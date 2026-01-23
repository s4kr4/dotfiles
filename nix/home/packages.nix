{ pkgs, lib, ... }:

let
  gwq = pkgs.buildGoModule rec {
    pname = "gwq";
    version = "0.0.7";

    src = pkgs.fetchFromGitHub {
      owner = "d-kuro";
      repo = "gwq";
      rev = "v${version}";
      sha256 = "sha256-CvfAxTd7/AK98TSJDM+iNJTUALMKMk8esXEn7Fuumik=";
    };

    vendorHash = "sha256-c1vq9yETUYfY2BoXSEmRZj/Ceetu0NkIoVCM3wYy5iY=";

    # サンドボックス環境ではホームディレクトリが/homeless-shelterになるためテストが失敗する
    doCheck = false;

    meta = with lib; {
      description = "Manage git worktree";
      homepage = "https://github.com/d-kuro/gwq";
      license = licenses.mit;
    };
  };
in
{
  home.packages = with pkgs; [
    # CLI基本ツール
    bat
    eza
    fd
    fzf
    ghq
    jq
    ripgrep
    tig
    tree
    wget

    # 開発ツール
    gh  # GitHub CLI
    git-lfs
    lazygit

    # システム
    htop
    unzip
    zip

    # ビルドツール
    automake
    pkg-config

    # カスタムパッケージ
    gwq
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux固有
    xclip
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS固有 (Homebrewで管理するものは除外)
  ];
}
