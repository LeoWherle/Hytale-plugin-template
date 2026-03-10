{
  pkgs,
  jdk,
  maven,
  hytaleHome,
  hytaleServer,
  hytaleAssets,
}: let
  genDevshell = release:
    assert builtins.typeOf release == "string";
      pkgs.mkShell {
        name = "MyPlugin environment";

        packages = [
          jdk
          maven
        ];

        JAVA_HOME = "${jdk.home}";

        shellHook = ''
          export HYTALE_SERVER_JAR="${hytaleServer hytaleHome release}"
          export HYTALE_ASSETS="${hytaleAssets hytaleHome release}"
          echo "——————————————————————————————————————"
          echo " MyPlugin dev shell"
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
in rec {
  default = release;
  release = genDevshell "release";
  pre-release = genDevshell "pre-release";
}
