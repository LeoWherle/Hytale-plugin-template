{
  description = "Hytale development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        # "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: let
        jdk = pkgs.jdk25;
        maven = pkgs.maven.override {jdk_headless = jdk;};
        hytaleHome = "$HOME/.var/app/com.hypixel.HytaleLauncher/data/Hytale";
        hytaleServer = home: release: home + "/install/${release}/package/game/latest/Server/HytaleServer.jar";
        hytaleAssets = home: release: home + "/install/${release}/package/game/latest/Assets.zip";
      in {
        devShells = import ./nix/devShells.nix {
          inherit pkgs jdk maven hytaleHome hytaleServer hytaleAssets;
        };

        packages = import ./nix/packages.nix {
          inherit pkgs jdk maven;
        };

        apps = import ./nix/apps.nix {
          inherit pkgs jdk maven hytaleHome hytaleServer hytaleAssets;
        };
      };
    };
}
