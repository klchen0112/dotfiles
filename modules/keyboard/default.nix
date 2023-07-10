{ pkgs, ... }: {
  home.packages = with pkgs; [
    # xmake
    # glib
    # gcc
    # julia
  ] ++ pkgs.stdenv.isLinux [
    qmk
  ];
}
