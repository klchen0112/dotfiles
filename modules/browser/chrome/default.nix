{
  den.aspects.chrome.chrome =
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
