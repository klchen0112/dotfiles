{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    cmake
    # xmake
    gcc
    # julia
  ];
}
