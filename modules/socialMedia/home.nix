{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [discord] ++ lib.optionals (pkgs.stdenv.isLinux) [];
}
