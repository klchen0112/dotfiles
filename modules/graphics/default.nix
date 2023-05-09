{pkgs, ...}: {
  home.packages = with pkgs; [
    openscad

    # xmake
    # glib
    # gcc
    # julia
  ];
}
