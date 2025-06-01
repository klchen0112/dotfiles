{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # qmk
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      vial
      qmk
    ];
}
