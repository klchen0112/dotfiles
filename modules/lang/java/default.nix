{
  flake.modules.homeManager.java =
    { pkgs, inputs, ... }:
    {
      programs.java = {
        enable = true;
        package = pkgs.jdk8;
      };
      programs.gradle = {
        enable = true;
        package = inputs.nur.legacyPackages."${pkgs.system}".repos.moaxcp.gradle-4_10_3;
      };
    };
}
