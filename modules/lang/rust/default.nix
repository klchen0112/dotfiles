{pkgs, ...}: {
  home.packages = with pkgs; [
    libiconv
    rustup
  ];
}
