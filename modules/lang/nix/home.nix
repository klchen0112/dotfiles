{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    # nixfmt
    # nix-du
    nil
    cachix
    devenv
    devbox
    statix
    deadnix
    nix-fast-build
  ];
}
