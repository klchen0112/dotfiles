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
        # gradle_7 was removed from nixpkgs (EOL); 8.x is the current stable line.
        package = pkgs.gradle_8;
      };
      programs.sbt = {
        enable = true;
      };
      home.packages = with pkgs; [
        maven3
      ];
    };
}
