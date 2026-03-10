{
  pkgs,
  jdk,
  maven,
}: let
  genPackages = release:
    assert builtins.typeOf release == "string";
      maven.buildMavenPackage {
        pname = "MyPlugin";
        version = "1.0.0";
        src = ./..;

        mvnJdk = jdk;
        mvnParameters = "-B package -DskipTests";

        mvnHash = "sha256-NjZUrSQV5AhP3yptYZJRm5KzLv2JRSFo25pTgrsR3rU="; # update regularly

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
in rec {
  default = release;
  release = genPackages "release";
  pre-release = genPackages "pre-release";
}
