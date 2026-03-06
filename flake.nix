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

      perSystem = {
        pkgs,
        # self',
        # config,
        # inputs',
        # system,
        ...
      }: let
        jdk = pkgs.jdk25;
        maven = pkgs.maven.override {jdk_headless = jdk;};
        hytaleHome = "$HOME/.var/app/com.hypixel.HytaleLauncher/data/Hytale";
        hytaleServer = home: home + "/install/release/package/game/latest/Server/HytaleServer.jar";
        hytaleAssets = home: home + "/install/release/package/game/latest/Assets.zip";
      in {
        devShells.default = pkgs.mkShell {
          name = "Hytale-Mod environment";

          packages = [
            jdk
            maven
          ];

          JAVA_HOME = "${jdk.home}";

          shellHook = ''
            export HYTALE_SERVER_JAR="${hytaleServer hytaleHome}"
            export HYTALE_ASSETS="${hytaleAssets hytaleHome}"
            echo "——————————————————————————————————————"
            echo " Hycrates dev shell"
            echo "   Java : $(java -version 2>&1 | head -1)"
            echo "   Maven: $(mvn --version 2>&1 | head -1)"
            echo "——————————————————————————————————————"

            check_file() {
              [ -f "$2" ] || printf '\033[31mWarning: %s not found at %s\033[0m\n' "$1" "$2";
            }

            check_file "Hytale server JAR" "$HYTALE_SERVER_JAR"
            check_file "Hytale assets" "$HYTALE_ASSETS"
          '';
        };

        packages.default = maven.buildMavenPackage {
          pname = "Hycrates";
          version = "1.0.0";
          src = ./.;

          mvnJdk = jdk;
          mvnParameters = "-B package -DskipTests";

          mvnHash = "sha256-2Sbkc3O+SAJqZJF203HIj7dpRauH0ZS6U4m/MRinEz8="; # update regularly

          nativeBuildInputs = [maven jdk];

          env.JAVA_HOME = "${jdk.home}";

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -rv target/. $out
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Built Hytale plugin (produced by 'mvn package')";
            license = licenses.mit;
            maintainers = [];
            platforms = platforms.linux;
          };
        };

        # For development only (nix run . -- server target)
        apps.default = {
          type = "app";
          program = let
            name = "run-server";
          in "${pkgs.writeShellScriptBin name ''
            export JAVA_HOME="${jdk.home}"
            export PATH="${jdk.home}/bin:${maven}/bin:$PATH"

            SERVER_DIR="$1"
            MODS_DIR="$2"

            if [ -z "$SERVER_DIR" ]; then
              printf '\033[31mError: server directory must be provided as the first argument\033[0m\n'
              exit 1
            fi
            if [ -z "$MODS_DIR" ]; then
              printf '\033[31mError: mods directory must be provided as the second argument\033[0m\n'
              exit 1
            else
                # get absolute path
                MODS_DIR=$(realpath "$MODS_DIR")
            fi

            # run from the server folder
            cd "$SERVER_DIR" || {
              printf '\033[31mError: failed to find server directory, if this is the first time create it first\033[0m\n'
              exit 1
            }

            export HYTALE_SERVER_JAR="${hytaleServer hytaleHome}"
            export HYTALE_ASSETS="${hytaleAssets hytaleHome}"

            exec "${jdk.home}/bin/java" -jar "$HYTALE_SERVER_JAR" --assets "$HYTALE_ASSETS" --mods "$MODS_DIR"
          ''}/bin/${name}";
        };
      };
    };
}
