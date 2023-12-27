{pkgs, ...}: {
  home.packages = with pkgs;
    [
    ]
    ++ lib.optionals pkgs.stdenv.isLinux
    [
      vial
      qmk
    ];
}
