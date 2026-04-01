{
  den.aspects.chrome =
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
