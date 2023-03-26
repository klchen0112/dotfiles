{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    # xmake
    glib
    gcc
    # julia
  ];
}
