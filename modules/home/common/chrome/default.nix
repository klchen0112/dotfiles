{ pkgs
, ...
}:
{
  programs.google-chrome = {
    enable = pkgs.stdenv.isLinux;
  };
}
