{pkgs, ...}: {
  home.packages = with pkgs; [
    # libiconv
    # libiconvReal
    rustup
  ];
}
