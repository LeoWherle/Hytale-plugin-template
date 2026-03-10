{
  pkgs,
  jdk,
  maven,
  hytaleHome,
  hytaleServer,
  hytaleAssets,
}: let
  genApps = release:
    assert builtins.typeOf release == "string"; {
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

        export HYTALE_SERVER_JAR="${hytaleServer hytaleHome release}"
        export HYTALE_ASSETS="${hytaleAssets hytaleHome release}"

        exec "${jdk.home}/bin/java" -jar "$HYTALE_SERVER_JAR" --assets "$HYTALE_ASSETS" --mods "$MODS_DIR"
      ''}/bin/${name}";
      meta = with pkgs.lib; {
        description = "Runs the server locally";
        license = licenses.mit;
        maintainers = [];
        platforms = platforms.linux;
      };
    };
in rec {
  default = release;
  release = genApps "release";
  pre-release = genApps "pre-release";
}
