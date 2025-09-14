{
  flake.modules.homeManager.chrome =
    {
      pkgs,
      ...
    }:
    {
      programs.google-chrome = {
        enable = pkgs.stdenv.isLinux;
      };
    };
}
