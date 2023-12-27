{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      discord
      # tdlib
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux)
    [
    ];
}
