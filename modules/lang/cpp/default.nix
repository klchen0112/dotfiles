{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    # xmake
    gcc
    # julia
  ];
}
