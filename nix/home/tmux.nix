{ pkgs, config, lib, ... }:

{
  programs.tmux = {
    enable = true;
  };

  # 既存の.tmux.confをリンク
  home.file.".tmux.conf".source = ../../.tmux.conf;
}
