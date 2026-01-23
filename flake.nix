{
  description = "s4kr4's dotfiles managed with Nix and Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS用 (将来対応)
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      # サポートするシステム
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # 各システムに対してattrsetを生成するヘルパー
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # システムごとのpkgs
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # ユーザー情報
      username = "s4kr4";
    in
    {
      # Home Manager設定
      homeConfigurations = {
        # Linux用
        "${username}@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          extraSpecialArgs = { inherit inputs username; };
          modules = [
            ./nix/home
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
          ];
        };

        # macOS用 (aarch64 - Apple Silicon)
        "${username}@darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "aarch64-darwin";
          extraSpecialArgs = { inherit inputs username; };
          modules = [
            ./nix/home
            {
              home.username = username;
              home.homeDirectory = "/Users/${username}";
            }
          ];
        };

        # macOS用 (x86_64 - Intel)
        "${username}@darwin-x86" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-darwin";
          extraSpecialArgs = { inherit inputs username; };
          modules = [
            ./nix/home
            {
              home.username = username;
              home.homeDirectory = "/Users/${username}";
            }
          ];
        };
      };

      # 開発シェル (nix develop)
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nil  # Nix LSP
              nixpkgs-fmt  # Nixフォーマッター
            ];
          };
        }
      );
    };
}
