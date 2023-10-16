{ pkgs, ... }: {
  home.packages = with pkgs; [
    # cmake
    # boost
    # clang-tools
    # xmake
    # glib
    # gcc
    # julia
    # llvm
  ];
}
