{
  den.aspects.java.java =
    { pkgs, ... }:
    {
      programs.java = {
        enable = true;
        package = pkgs.jdk17;
      };
      programs.gradle = {
        enable = true;
        package = pkgs.gradle_7;
      };
      programs.sbt = {
        enable = true;
      };
      home.packages = with pkgs; [
        maven3
      ];
      nixpkgs.config.permittedInsecurePackages = [
        "gradle-7.6.6"
      ];
    };
}
