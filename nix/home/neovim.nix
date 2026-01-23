{ pkgs, config, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # LSPサーバー等はプラグインマネージャー(lazy.nvim)が管理するため、
    # ここでは最小限のツールのみ
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };

  # 既存のnvim設定をリンク
  xdg.configFile."nvim" = {
    source = ../../nvim;
    recursive = true;
  };
}
