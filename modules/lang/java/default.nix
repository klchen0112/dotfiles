{
  flake.modules.homeManager.java =
    { pkgs, inputs, ... }:
    {
      programs.java = {
        enable = true;
        package = pkgs.jdk17;
      };
      programs.gradle = {
        enable = true;
        package = pkgs.gradle_7;
      };
      nixpkgs.config.permittedInsecurePackages = [
        "gradle-7.6.6"
      ];
    };
}
