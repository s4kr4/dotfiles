{ pkgs, config, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # 既存の.zshrc, .zshenvをリンク
  home.file.".zshrc".source = ../../.zshrc;
  home.file.".zshenv".source = ../../.zshenv;

  # zsh追加設定
  xdg.configFile."zsh" = {
    source = ../../zsh;
    recursive = true;
  };
}
