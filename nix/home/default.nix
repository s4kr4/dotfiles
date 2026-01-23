{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./tmux.nix
    ./zsh.nix
    ./neovim.nix
  ];

  # Home Manager基本設定
  home.stateVersion = "24.11";

  # Home Managerで管理することを明示
  programs.home-manager.enable = true;

  # XDG Base Directory
  xdg.enable = true;

  # 環境変数
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    DOTPATH = "${config.home.homeDirectory}/.dotfiles";
  };

  # カスタムスクリプト
  home.file."bin" = {
    source = ../../bin;
    recursive = true;
  };
}
