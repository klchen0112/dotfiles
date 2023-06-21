{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    boost
    # xmake
    # glib
    # gcc
    # julia
  ];
}
