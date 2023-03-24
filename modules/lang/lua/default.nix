{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    lua5_3_compat
    lua53Packages.fennel
  ];
}
