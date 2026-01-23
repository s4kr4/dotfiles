{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # 既存の.gitconfigをリンク
  home.file.".gitconfig".source = ../../.gitconfig;

  # 既存の.tigrcをリンク（tigの設定も.gitconfigに含まれているが念のため）
}
