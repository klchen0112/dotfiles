{pkgs, ...}: {
  home.packages = with pkgs; [
    qmk

    # xmake
    # glib
    # gcc
    # julia
  ];
}
